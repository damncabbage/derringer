#### App ####

class Derringer extends Batman.App
  @set 'search', 'Rob'
  @set 'results', []
  @set 'result', null

  # Make Derringerbm available in the global namespace so it can be used
  # as a namespace and bound to in views.
  @global yes

  # Routes
  @route 'search/:term', 'app#search'
  @root 'app#index'


#### Models ####

class Derringer.Order extends Batman.Model
  @global yes
  @persist Batman.LocalStorage
  @hasMany 'tickets'
  @encode 'id', 'code', 'full_name', 'history', 'created_at', 'updated_at'

class Derringer.Ticket extends Batman.Model
  @global yes
  @persist Batman.LocalStorage
  @belongsTo 'order'
  @hasMany 'scans'
  @encode 'id', 'code', 'full_name', 'gender', 'age', 'created_at', 'updated_at'

class Derringer.Scan extends Batman.Model
  @global yes
  @persist Batman.LocalStorage
  @belongsTo 'ticket'
  @encode 'id', 'booth', 'created_at'


#### Widgets ####

class Derringer.SearchBox extends Batman.Object
  @set 'value', ''

# class Derringer


#### Controllers ####

class Derringer.AppController extends Batman.Controller
  index: ->
    resetSearch()
    Order.load (error, orders) ->
      unless orders and orders.length
        callback = (error) -> throw error if error

        # Dummy record creation
        t = new Ticket(full_name: 'Rob Howard', code: 'S1-1231234X-0041')
        o1 = new Order(full_name: "Rob Howard", code: 'S1-1231234X')
        o1.set('tickets', new Batman.Set(
          new Derringer.Ticket(full_name: 'Rob Howard', code: 'S1-1231234X-0041'),
          new Derringer.Ticket(full_name: 'Andrew Howard', code: 'S1-1231234X-0042')
        ))
        o1.save(callback)
        t.save(callback) for t in o1.get('tickets').toArray()

        o2 = new Order(full_name: "Geoffrey Roberts", code: 'S1-23214X13')
        o2.set('tickets', new Batman.Set(
          new Ticket(full_name: 'Michael Camilleri', code: 'S1-23214X13-0062'),
          new Ticket(full_name: 'Thomas Munro', code: 'S1-23214X13-006F')
        ))
        o2.save(callback)
        t.save(callback) for t in o2.get('tickets').toArray()


  search: (params) ->
      startSearch()
      terms = getValueFromFormParams(params, 'terms')
      # Really dumb search that barely works, isn't going to scale and
      # doesn't even hit persistent storage.
      Order.load (error, orders) ->
        results = (order for order in orders when order.get('full_name').toLowerCase().indexOf(terms.toLowerCase()) >= 0)
        window.Derringer.set 'results', results
        finishSearch()

  order: (params) ->

  ticket: (params) ->

  # Routes can optionally be declared inline with the callback on the controller:
  #
  # order: @route('/order/:id', (params) -> ... )
  # ticket: @route('/ticket/:id', (params) -> ... )

  # Add functions to run before an action with
  #
  # @beforeFilter 'someFunctionKey'  # or
  # @beforeFilter -> ...

  # HACK: Because Batman.js is sometimes terrible and has no documentation.
  # ... And gives you different things depending if it's a form
  # submit or a "get" request via data-route.
  # (tl;dr Controller params can be a form element or a straight value. :-| )
  getValueFromFormParams = (params, param) ->
    value = null
    if params[param]?
      if params[param].value?
        value = params[param].value
      else
        value = params[param]
    value

  # Search animation helpers
  resetSearch = ->
    frm = $('#form')
    $('.tip', frm).removeClass('fold')
    $('#instructions').removeClass('fold')
    $('#results').addClass('fold').removeClass('loading').removeClass('done')

  startSearch = ->
    frm = $('#form')
    $('.tip', frm).addClass('fold')
    $('#instructions').addClass('fold')
    $('#results').addClass('loading').removeClass('fold')

  finishSearch = ->
    $('#results').removeClass('loading').addClass('done')


  # Panel-slide animation helpers
  activateSearchPanel = ->
    $('#search-panel').removeClass('left')
    $('#result-panel').addClass('right')

  activateOrderPanel = ->
    $('#search-panel').addClass('left')
    $('#result-panel').removeClass('right')

