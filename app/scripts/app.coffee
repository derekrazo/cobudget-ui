'use strict'

app = angular.module('cobudget', [
  'ngCookies',
  'ngResource', #may not need if restangular
  'restangular',
  'ngSanitize',
  'directive.g+signin',
  'ngAnimate',
  'angular-lodash'
  'angles'
  'flash'
  'colorpicker.module'
  'btford.markdown'
  'xeditable'
  'ui.router'
  'ui.bootstrap'
  'filters.utils'
  'controllers.buckets'
  'controllers.budgets'
  'states.base'
  'states.budget'
  'states.bucket'
  'states.admin'
  'resources.budgets'
  'resources.buckets'
  'resources.users'
  'resources.accounts'
  'resources.allocations'
  'services.constrained_slider_collector'
  'services.color_generator'
  'directives.expander'
  'directives.slider'
  'directives.constrained_slider'
  'directives.horiz_graph'
  'directives.manage_users'
  'directives.manage_allocation_rights'
  'directives.manage_budget'
  'directives.sessions'
])
#.constant("API_PREFIX", "http://api.cobudget.enspiral.info/cobudget")
#:9393 = shotgun, :9292 = rackup
.constant("API_PREFIX", "http://localhost:9292/cobudget")
.config(["$httpProvider", '$urlRouterProvider', '$sceDelegateProvider', 'RestangularProvider', 'API_PREFIX', ($httpProvider, $urlRouterProvider, $sceDelegateProvider, RestangularProvider, API_PREFIX)->
  $httpProvider.interceptors.push('authInterceptor')

  $urlRouterProvider.otherwise('/')
  RestangularProvider.setBaseUrl(API_PREFIX)
  #RestangularProvider.setFullRequestInterceptor((element, operation, route, url, headers, params, httpConfig)->
    #element: element
    #params: _.extend(params, {single: true})
    #headers: headers
    #config: httpConfig
  #)
  #RestangularProvider.configuration.getIdFromElem = (elem)->
  #elem[_.initial(elem.route).join('') + "_id"]
  #$httpProvider.defaults.headers.post["Content-Type"] = "application/x-www-form-urlencoded"
  #$sceDelegateProvider.resourceUrlWhitelist(['self', 'http://localhost:9000/**', 'http://localhost:9292/**', 'http://127.0.0.1:9292/**', 'http://cobudget.enspiral.info/**'])
])
.run(["$rootScope", "$http", "$state", "API_PREFIX", "editableOptions", "User", ($rootScope, $http, $state, API_PREFIX, editableOptions, User) ->
  $rootScope.setUser = (id)->
    id ||= 3
    User.getUser(id).then (success)->
      User.setCurrentUser(success)
      if User.getCurrentUser()?
        $state.go 'budgets.buckets', budget_id: 1
      else
        $state.go '/'
  #$rootScope.setUser()
  #
  $rootScope.$on 'event:google-plus-signin-success', (event,authResult)->
    console.log authResult
    gapi.client.load 'plus','v1', ()->
      request = gapi.client.plus.people.get({'userId': 'me'})
      request.execute (resp)->
        emails = resp.emails.filter (v)->
          v.type == 'account'
        console.log emails[0].value
      #gapi.client.plus.people.get( {'userId' : 'me'} ).execute((obj)->
        #console.log obj
        #obj['emails'].filter((v)-> 
            #v.type == 'account'
          #)[0].value
      #)
  $rootScope.$on 'event:google-plus-signin-failure', (event,authResult)->

    console.log authResult

  $rootScope.$debugMode = "on"
  $rootScope.admin = false

  editableOptions.theme = 'cobudget'

  $rootScope.pusher = new Pusher('6ea7addcc0137ddf6cf0')
  $rootScope.channel = $rootScope.pusher.subscribe('cobudget')

  $rootScope.toggleAdmin = ()->
    $rootScope.admin = !$rootScope.admin

  Pusher.log = (message)-> 
    if window.console && window.console.log
      window.console.log(message)
])
.factory('authInterceptor', ($rootScope, $q, $window)->
  request: (config)->
    config.headers = config.headers || {}
    if $window.sessionStorage.token?
      config.headers.Authorization = 'Bearer ' + $window.sessionStorage.token
    console.log config
    config
  responseError: (rejection)->
    console.log "RESPONSE ERROR:", rejection
    if rejection.status == 401
      $rootScope.$broadcast("auth:access_denied")
      #window.location = "/"
    $q.reject(rejection)
)
