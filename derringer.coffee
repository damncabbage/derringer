#window.App =
#  Models: {}
#  Collections: {}
#  Views: {}

# Bind everything inside a self-calling anonymous function.
(($) ->

  ##### Routers #####

  class Derringer extends Backbone.Router
    routes: {
      '': 'index'
      'search/': 'index'
      'search/*terms': 'search'
      'orders/:id': 'order'
    }

    initialize: =>
      this.orderSearchView = new OrderSearchView(
        collection: window.orders
      )

    index: ->
      this.orderSearchView.terms = "" 
      this.orderSearchView.render()

      $('#order-panel').addClass('right')
      $('#search-panel').removeClass('left').removeClass('show-results')
      $('#terms').focus()


    search: (terms) ->
      this.orderSearchView.terms = unescape(terms)
      #this.orderSearchView.collection.forTerms(terms)

      $('#order-panel').addClass('right')
      $('#search-panel').removeClass('left').addClass('show-results')
      $('#search-results').addClass('loading');

      window.orders.fetch({
        url: '/orders.json',
        success: (collection, response) =>
          this.orderSearchView.collection = window.orders
          this.orderSearchView.render()
          $('#search-results').removeClass('loading').addClass('done');
          $('#terms').focus()
      })# Swap this with the terms search URL when CouchDB is in.


    order: (id) ->
      $('#search-panel').addClass('left')
      $('#order-panel').removeClass('right')
      window.orders.fetch({
        url: '/orders.json',
        success: (collection, response) =>
          order = window.orders.get(id)
          view = new OrderView(model: order)
          view.render()
      })

  ##### Models #####

  class Order extends Backbone.Model
    defaults: {
      code: ""
      full_name: ""
      tickets: []
    }

  class Orders extends Backbone.Collection
    model: Order
    url: '/orders.json'

    all: =>
      #[ new Order(full_name: "Rob Howard", code: 'S1-1231234X') ]

    forTerms: (terms) =>
      # Really dumb search that barely works and isn't going to scale.
      this.filter (order) ->
        order.get('full_name').toLowerCase().indexOf(terms.toLowerCase()) >= 0

    forCode: (code, strict=true) =>
      if strict
        this.filter ->
          order.get('code').toLowerCase() == code.toLowerCase()
      else
        this.filter ->
          order.get('code').toLowerCase().indexOf(code.toLowerCase()) == 0


  class Scan extends Backbone.Model
    defaults: {
      code: ""
      booth: ""
      created_at: ""
    }

  class Scans extends Backbone.Collection
    model: Scan
    url: '/scans.json'

    forOrderByCode: (code) =>
      this.filter (scan) ->
        window.orders.forCode(code, false) != []

  window.orders = new Orders
  window.scans = new Scans


  ##### Views #####

  class OrderView extends Backbone.View
    el: '#order'

    initialize: =>
      this.model.bind('change', this.render)
      this.template = _.template $('#order-template').html()

    render: (event) =>
      this.$el.html this.template(this.model.toJSON())
      return this

    events: {
      'click .back': 'back'
      'click .confirm': 'confirm'
    }

    back: (event) ->
      if window.history.length > 0
        window.history.back()
      else
        window.App.navigate('/', true)

    confirm: (event) ->


  class OrderSearchView extends Backbone.View
    el: '#search'

    initialize: =>
      this.template = _.template $('#search-template').html()

    render: (event) =>
      this.$el.html this.template(
        collection: this.collection.toJSON()
      )
      # Safely set the value.
      this.$el.find('#terms').val((this.terms || ""))
      return this

    events: {
      'submit #search-form': 'search'
      'click .order': 'select'
    }

    search: (event) ->
      event.preventDefault()
      $input = $(event.target).find('#terms')
      window.App.navigate "/search/#{escape($input.val())}", true

    select: (event) ->
      id = $(event.target).closest('.order').attr('data-id')
      window.App.navigate "/orders/#{escape(id)}", true


  class ScanView extends Backbone.View
    el: '#search-notice'

    initialize: =>
      this.template = _.template $('#search-notice-template').html()

    render: (event) =>
      this.$el.html this.template(this.model.toJSON())
      return this

    events: {
      'add': 'notice'
    }

    notice: (event) ->
      # TODO: How do I know what's changed?


  ##### Run ######

  $(document).ready ->
    # Let's dance.
    window.App = new Derringer()
    Backbone.history.start({ pushState: false });

)(jQuery)

