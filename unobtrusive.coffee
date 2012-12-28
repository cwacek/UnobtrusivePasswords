unobtrusive = angular.module "UnobtrusivePasswords", ['ui']

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

    push: (element) ->
      @data.element = true

    asList: ->
      (element for element in @data when element is true)

    pop: (element) ->
      delete @data.element

  History =
    key: null
    url_list: new UniqueList()

    initialize: (k) ->
      @key = k
      chrome.storage.local.get @key, (item) ->
        @url_list = if $.isEmptyObject(item) then new UniqueList() else item.k

    addUrl: (url)->
      @url_list.push(url)
      chrome.storage.local.set {key: @url_list}


unobtrusive.controller 'UnobtrusiveCtrl', ($scope, MyCrypto, History) ->

  History.initialize('unobtrusive')

  ###
  # The main functionality
  ###
  $scope.hashlist = []
  $scope.haveResult = false

  $scope.doHash = ->
    MyCrypto.initialize $scope.site, $scope.password

    $scope.hashList = (MyCrypto.getNext $scope.password for x in [1..3])
    $scope.haveResult = true
    if ($scope.save )
      History.addUrl($scope.site)

  # Watch the form validity and hide the things if its invalid
  $scope.$watch (scope)->
      return scope.input_form.$valid if scope.input_form?
      return null
    , (oldv,newv,scope)->
      $scope.haveResult = false if newv == false
