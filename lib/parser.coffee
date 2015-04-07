URLHandler = require './urlhandler.coffee'
ADBreak = require './adbreak.coffee'
ADData = require './addata.coffee'

class VMAPParser

	@parse: (url, options, cb) ->
		if not cb
			cb = options if typeof options is 'function'
			options = {}

		@_parse url, null, options, (err, response) ->
            cb(response)

    @_parse: (url, parentURLs, options, cb) ->

	# Parsing node text for legacy support
    @parseNodeText: (node) ->
        return node and (node.textContent or node.text or '').trim()

    # Validate url
    @isUrl: (node) ->
        /[-a-zA-Z0-9@:%._\+~#=]{2,256}\.[a-z]{2,6}\b([-a-zA-Z0-9@:%_\+.~#?//=]*)/i.test (@parseNodeText node)

module.exports = VMAPParser