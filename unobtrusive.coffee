unobtrusive = angular.module "UnobtrusivePasswords", ['ui','oblique.directives']

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


unobtrusive.controller 'UnobtrusiveCtrl', ($scope, MyCrypto, History) ->

  History.initialize('unobtrusive')

  $scope.autocmp_src = History.url_list.filter()

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
  $scope.$watch 'input_form' 
    , (newv,oldv,scope)->
      console.log newv
      $scope.haveResult = false if newv == false
