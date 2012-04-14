#### App ####

class Derringer extends Batman.App
  @set 'mission', 'fight crime'

  # Make Derringerbm available in the global namespace so it can be used
  # as a namespace and bound to in views.
  @global yes

  # Source the AppController and set the root route to AppController#index.
  #@controller 'app'
  @root 'app#index'


#### Models ####

class Derringer.Order extends Batman.Model
  @global yes
  @persist Batman.LocalStorage
  @hasMany 'tickets'
  @encode 'id', 'code', 'full_name', 'history', 'created_at', 'updated_at'
  #@encode 'created_at', 'updated_at', Batman.Encoders.railsDate

class Derringer.Ticket extends Batman.Model
  @global yes
  @persist Batman.LocalStorage
  @belongsTo 'order'
  @hasMany 'scans'
  @encode 'id', 'code', 'full_name', 'gender', 'age', 'created_at', 'updated_at'
  #@encode 'created_at', 'updated_at', Batman.Encoders.railsDate

class Derringer.Scan extends Batman.Model
  @global yes
  @persist Batman.LocalStorage
  @belongsTo 'ticket'
  @encode 'id', 'booth', 'created_at'
  #@encode 'created_at', Batman.Encoders.railsDate


#### Controllers ####

class Derringer.AppController extends Batman.Controller
  index: ->

   search: (params) ->

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





