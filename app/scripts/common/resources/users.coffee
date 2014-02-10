angular.module('resources.users', [])
.service("User", ['Restangular', '$http', '$window', '$state', (Restangular, $http, $window, $state) ->
  users = Restangular.all('users')
  current_user = {}

  setCurrentUser =  (user_data)->
    current_user = user_data

  allUsers: ()->
    users.getList()

  getUser: (user_id)->
    Restangular.one('users', user_id).get()

  getUserAllocations: (user_id)->
    Restangular.one('buckets', budget_id).getList('allocations')

  updateUser: (user_data)->
    user = Restangular.one('users', user_data.id).customPUT(user_data)

  createUser: (user_data)->
    users.post('users', user_data)

  getCurrentUser: ->
    current_user

  refreshCurrentUser: ->
    @getUser(current_user.id).then (success)->
      current_user = success

  authUser: (params)->
    #users.post('authenticate', params).then (success)->
      #console.log success
    $http.post('http://localhost:9292/cobudget/users/authenticate', params)
    .success (data, status, headers, config)->
      token = data.token.replace(/"/g, "")
      $window.sessionStorage.token = token
      data.token = null
      setCurrentUser(data)
      console.log current_user
      $state.go('budgets.buckets', budget_id: 1)
    .error (data, status, headers, config)->
      console.log data, status
      #Erase the token if the user fails to log in
      delete $window.sessionStorage.token
])
