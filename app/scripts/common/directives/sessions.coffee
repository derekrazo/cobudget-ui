angular.module("directives.sessions", [])
.directive "sessions", ['$rootScope', 'User', ($rootScope, User) ->
  restrict: "EA"
  transclude: "false"
  templateUrl: "views/directives/sessions.html"

  link: (scope, element, attrs) ->
    scope.ux = {}
    scope.ux.register = false
    scope._user = {}

    scope.signIn = ->
      scope._user.password_confirmation = null
      User.authUser({email: scope._user.email, password: scope._user.password})
      console.log scope._user

    scope.register = ->
      if scope._user.password_confirmation != scope._user.password
        console.log "Password mismatch"
        return false
      console.log scope._user
      User.createUser(scope._user).then (success)->
        User.authUser({email: success.email, password: scope._user.password})
        #scope._user = {}
]
