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

unobtrusive.factory 'History', ->
  class UniqueList
    constructor:  ->
      @data = {}

    load: (array)->
      (@push element for element in array)

    push: (element) ->
      @data[element] = true

    asList: (filter)->

      if filter?
        filterpieces = filter.split '.'
        re = new RegExp (filterpieces.join("\\."))
      else
        re = new RegExp '.*'
      (element for element,valid of @data when valid && re.test element )

    pop: (element) ->
      delete @data[element]

    filter: ->
      me = @
      (request, response) ->
        response me.asList(request.term)

  History =
    key: null
    url_list: new UniqueList()

    initialize: (k) ->
      @key = k
      _key = @key
      _url_list = @url_list
      chrome.storage.local.get @key, (item) ->
        if ! $.isEmptyObject item
          _url_list.load item[_key]

    addUrl: (url)->
      @url_list.push(url)
      entry = {}
      entry[@key] = @url_list.asList()
      chrome.storage.local.set entry

    remove: (key)->
      @url_list.pop(key)
      entry = {}
      entry[@key] = @url_list.asList()
      chrome.storage.local.set entry

unobtrusive.factory 'Settings', ->
  Settings =
    settings:
      p_length: 10

    get: (key)->
      @settings[key]

    set: (key,val)->
      @settings[key] = val

    apply: ->
      self = this
      storage_entry =
        unobtrusive_settings: @settings
      chrome.storage.local.set storage_entry

    initialize: ->
      self = this
      chrome.storage.local.get "unobtrusive_settings", (item) ->
        if ! $.isEmptyObject item
          self.settings = item["unobtrusive_settings"]

unobtrusive.controller 'UnobtrusiveCtrl', ($scope, MyCrypto, History, Settings, $location) ->

  History.initialize('unobtrusive')

  $scope.autocmp_src = History.url_list.filter()

  ###
  # The main functionality
  ###
  $scope.hashlist = []
  $scope.in_settings = false
  $scope.haveResult = false

  Settings.initialize()

  $scope.doHash = ->
    MyCrypto.initialize $scope.site, $scope.password

    $scope.hashList = (MyCrypto.getNext($scope.password, Settings.get("p_length")) for x in [1..3])
    $scope.haveResult = true
    History.addUrl($scope.site)

  $scope.showResults = ->
    $scope.haveResult = false if not $scope.input_form.$valid
    ($scope.haveResult and $scope.input_form.$valid)

  $scope.toggleSettings = ->
    if $scope.in_settings
      path = "/"
      Settings.apply()
    else
      path = '/settings'
    $location.path(path)
    $scope.in_settings = ! $scope.in_settings

unobtrusive.controller 'UnobtrusiveSettingsCtrl', ($scope, History, Settings, $location) ->

  $scope.settings =
    Settings.settings

  $scope.history = ->
    History.url_list.asList()

  $scope.toggleSettings = ->
    Settings.apply()
    $location.path("/")

  $scope.removeKey = (key) ->
    console.log "Removal of #{key} requested"
    History.remove(key)


unobtrusive.config ['$routeProvider', ($routeProvider) -> (
  $routeProvider.when '/', {templateUrl: 'p_form.html', controller: 'UnobtrusiveCtrl'}
  $routeProvider.when '/settings', {templateUrl: 'p_settings.html', controller: 'UnobtrusiveSettingsCtrl'}
  $routeProvider.otherwise {redirectTo: '/'}
)]
