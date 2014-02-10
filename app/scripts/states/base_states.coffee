angular.module('states.base', [])
.config(['$stateProvider', '$urlRouterProvider', ($stateProvider, $urlRouterProvider)->
  $stateProvider.state('sessions',
    url: '/'
    views:
      'main':
        templateUrl: '/views/home.html'
        controller: ['$scope', ($scope)->
          console.log 'HOME:'
        ]
  ) #end state
]) #end config

