VMAPParser = require './parser.coffee'
VMAPUtil = require './util.coffee'

class VMAPClient
	@options:
		withCredentials: true,
		timeout: 0

	@hello: ->
		console.log('Hello world!')


module.exports = VMAPClient