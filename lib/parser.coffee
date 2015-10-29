URLHandler = require './urlhandler.coffee'
AdBreak = require './adbreak.coffee'
AdSource = require './addata.coffee'
VMAPResponse = require './vmapresponse.coffee'
EventEmitter = require('events').EventEmitter
VMAPUtil = require './vmaputil.coffee'
# sys = require 'sys'

# puts = (obj) ->
#   sys.puts(sys.inspect(obj))

class VMAPParser
  @parse: (url, options, cb) ->
    if not cb
      cb = options if typeof options is 'function'
      options = {}

    @_parse url, null, options, (err, response) ->
      cb(response)

  @vent = new EventEmitter()
  @track: (templates, errorCode) ->
    @vent.emit 'VMAP-error', errorCode
    VMAPUtil.track(templates, errorCode)

  @_parseSource: (err, xml, cb) ->
    return cb(err) if err?
    response = new VMAPResponse()
    response.adbreaks = [] # Hack

    unless xml?.documentElement? and ((xml.documentElement.nodeName is 'VMAP') or (xml.documentElement.nodeName is 'vmap:VMAP'))
      return cb()

    for node in xml.documentElement.childNodes
      if node.nodeName is 'Error'
        response.errorURLTemplates.push (@parseNodeText node)

    for node in xml.documentElement.childNodes
      switch node.nodeName
        when "vmap:AdBreak"
          adBreak = @parseAdBreakElement node
          if adBreak?
            response.adbreaks.push adBreak
          else
            @track(response.errorURLTemplates, ERRORCODE: 101)

        when "vmap:Extensions"
          extensions = @parseExtensionElement node

    complete = (errorAlreadyRaised = false) =>
      return unless response

      if response.adbreaks.length == 0
        # No AdBreak Response
        # The VMAP <Error> element is optional but if included, the video player must send a request to the URI
        # provided when the VMAP response returns an empty InLine response after a chain of one or more wrapper ads.
        # If an [ERRORCODE] macro is included, the video player should substitute with error code 303.
        @track(response.errorURLTemplates, ERRORCODE: 303) unless errorAlreadyRaised
        response = null
      cb(null, response)

    complete()

  @_parse: (url, parentURLs, options, cb) ->
    if not cb
      cb = options if typeof options is 'function'
      options = {}
    # Process url with defined filter
    # url = filter(url) for filter in URLTemplateFilters

    URLHandler.get url, options, (err, xml) =>
      @_parseSource err, xml, cb

  ###*
   * Parse extensions field
   * @todo  implement extensions
   * @param  {node} extensionsElement xml dom node for extensions
   * @return {json}                   return extensions or xml document
  ###
  @parseExtensionElement: (extensionsElement) ->
    return null

  @parseAdBreakElement: (adBreakElement) ->
    adBreak = new AdBreak()

    ###*
     * @todo May contains multiple break type.
     * @type {[type]}
    ###
    adBreak.breakType = adBreakElement.getAttribute("breakType")
    adBreak.breakId = adBreakElement.getAttribute("breakId")
    adBreak.timeOffset = adBreakElement.getAttribute("timeOffset")

    for node in adBreakElement.childNodes
      switch node.nodeName
        when "vmap:AdSource"
          adSource = @parseAdSource(node)
          if adSource
            adBreak.allowMultipleAds = adSource.allowMultipleAds
            adBreak.followRedirects = adSource.followRedirects
            adBreak.id = adSource.id
            adBreak.templateType = adSource.templateType
            adBreak.vastAdData = adSource.vastAdData
            adBreak.adTagURI = adSource.adTagURI
            adBreak.isWrapper = adSource.isWrapper

        when "vmap:TrackingEvents"
          trackingEvents = @parseTrackingEvent(node)
          if trackingEvents
            adBreak.trackingEvent = trackingEvents

        when "vmap:Extensions"
          # TODO: implement extension support
          extensions = @parseExtensionElement node

    return adBreak

  @parseTrackingEvent: (trackingEventElement) ->
    trackingEvent = {}
    trackingEvent.breakStart = []
    trackingEvent.breakEnd = []
    trackingEvent.error = []
    for trackingElement in trackingEventElement.childNodes
      continue if trackingElement.getAttribute == undefined
      switch trackingElement.getAttribute("event")
        when "breakStart"
          trackingEvent.breakStart.push(@parseNodeText(trackingElement))

        when "breakEnd"
          trackingEvent.breakEnd.push(@parseNodeText(trackingElement))

        when "error"
          trackingEvent.error.push(@parseNodeText(trackingElement))

    return trackingEvent

  @parseAdSource: (adSourceElement) ->
    adSource = new AdSource()
    adSource.allowMultipleAds = VMAPUtil.parseBoolean(adSourceElement.getAttribute('allowMultipleAds'))
    adSource.followRedirects = VMAPUtil.parseBoolean(adSourceElement.getAttribute('followRedirects'))
    adSource.id = adSourceElement.getAttribute("id")

    for node in adSourceElement.childNodes
      switch node.nodeName
        when "vmap:VASTData"
          adSource.vastAdData = node.childNodes
          adSource.templateType = "vast3" # Extend for original

        when "vmap:AdTagURI"
          adSource.adTagURI = @parseNodeText(node)
          adSource.templateType = node.getAttribute("templateType")
          adSource.isWrapper = true

        when "vmap:CustomAdData"
          adSource.vastAdData = node.childNodes
          adSource.templateType = node.getAttribute("templateType")

    return adSource

  # Parsing node text for legacy support
  @parseNodeText: (node) ->
    return node and (node.textContent or node.text or '').trim()

  # Validate url
  @isUrl: (node) ->
    /[-a-zA-Z0-9@:%._\+~#=]{2,256}\.[a-z]{2,6}\b([-a-zA-Z0-9@:%_\+.~#?//=]*)/i.test (@parseNodeText node)

# root = exports ? window
# root.VMAPParser = VMAPParser
module.exports = VMAPParser
