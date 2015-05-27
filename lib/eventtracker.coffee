VMAPUtil = require './vmaputil.coffee'
EventEmitter = require('events').EventEmitter

class EventTracker extends EventEmitter

  constructor: (trackingEvents) ->
    @trackingEvents = trackingEvents

  breakStart: ->
    @track "breakStart"

  breakEnd: ->
    @track "breakEnd"

  error: (error) ->
    @track "error", no, error

  track: (eventName, once=no, variables) ->
    trackingURLTemplates = @trackingEvents[eventName]

    if trackingURLTemplates?
      @trackURLs trackingURLTemplates

    if once is yes
      delete @trackingEvents[eventName]
    return

  trackURLs: (URLTemplates, variables) ->
    variables ?= {}
    VMAPUtil.track(URLTemplates, variables)

module.exports = EventTracker
