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
      'search/:terms': 'search'
      'orders/:id': 'order'
    }

    initialize: =>
      this.orderSearchView = new OrderSearchView(
        collection: window.orders
      )

    index: ->
      this.orderSearchView.terms = "" 
      this.orderSearchView.render()
      $('#result-panel').addClass('right')
      $('#search-panel').removeClass('left').removeClass('show-results')

      #$('#search-results').addClass('fold').removeClass('loading').removeClass('done')


    search: (terms) ->
      this.orderSearchView.terms = terms
      console.log(this.orderSearchView)
      this.orderSearchView.collection.forTerms(terms)
      this.orderSearchView.render()
      $('#result-panel').addClass('right')
      $('#search-panel').removeClass('left').addClass('show-results')

#      $results.addClass('loading')
#      $results.removeClass('loading').addClass('done')


    order: (id) ->
      $('#search-panel').addClass('left')
      $('#result-panel').removeClass('right')
      item = Orders.get(id)
      view = new OrderView(model: item)


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
    confirm: (event) ->


  class OrderSearchView extends Backbone.View
    el: '#search'

    initialize: =>
      this.template = _.template $('#search-template').html()

    render: (event) =>
      this.$el.html this.template({
        terms: (this.terms || "")
        collection: this.collection.toJSON()
      })
      return this

    events: {
      'submit #search-form': 'search'
      'click .order': 'select'
    }

    search: (event) ->
      event.preventDefault()
      $input = $(event.target).find('#terms')
      newUrl = '/search/' + escape($input.val())
      window.App.navigate newUrl, true

    select: (event) ->


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

