unobtrusive = angular.module "UnobtrusivePasswords", ['ui','oblique.directives']

unobtrusive.directive 'eatClick', ->
  opts =
    link: (scope, elem, attrs)->
      elem.click (event)->
        event.preventDefault()

unobtrusive.factory 'MyCrypto', ->
  return MyCrypto =
    curr: null

    initialize: (text,key) ->
      @curr = CryptoJS.HmacSHA256 text, key

    getNext: (key,len) ->
      return "MyCrypto not initialized" if !@curr
      @curr = CryptoJS.HmacSHA256 @curr, key
      output = CryptoJS.enc.Base64.stringify @curr
      return output.substring 0, len || 10


unobtrusive.factory 'Settings', ->
  Settings =
    settings:
      p_length: 10

    get: (key)->
      @settings[key]

    set: (key,val)->
      @settings[key] = val


unobtrusive.controller 'UnobtrusiveCtrl', ($scope, MyCrypto,  Settings, $location) ->

  ###
  # The main functionality
  ###
  $scope.hashlist = []
  $scope.in_settings = false
  $scope.haveResult = false

  $scope.doHash = ->
    MyCrypto.initialize $scope.site, $scope.password

    $scope.hashList = (MyCrypto.getNext($scope.password, Settings.get("p_length")) for x in [1..3])
    $scope.haveResult = true

  $scope.showResults = ->
    $scope.haveResult = false if not $scope.input_form.$valid
    ($scope.haveResult and $scope.input_form.$valid)

  $scope.toggleSettings = ->
    if $scope.in_settings
      path = "/"
    else
      path = '/settings'
    $location.path(path)
    $scope.in_settings = ! $scope.in_settings

unobtrusive.controller 'UnobtrusiveSettingsCtrl', ($scope,  Settings, $location) ->

  $scope.settings =
    Settings.settings

  $scope.toggleSettings = ->
    $location.path("/")

unobtrusive.config ['$routeProvider', ($routeProvider) -> (
  $routeProvider.when '/', {templateUrl: 'p_form.html', controller: 'UnobtrusiveCtrl'}
  $routeProvider.when '/settings', {templateUrl: 'p_settings.html', controller: 'UnobtrusiveSettingsCtrl'}
  $routeProvider.otherwise {redirectTo: '/'}
)]
