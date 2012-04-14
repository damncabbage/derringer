#### App ####

class Derringer extends Batman.App
  @set 'mission', 'fight crime'

  # Make Derringerbm available in the global namespace so it can be used
  # as a namespace and bound to in views.
  @global yes

  # Source the AppController and set the root route to AppController#index.
  #@controller 'app'
  @root 'app#index'


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





