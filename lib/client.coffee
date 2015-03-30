VMAPParser = require './parser.coffee'
VMAPUtil = require './util.coffee'

class VMAPClient
	@options:
		withCredentials: true,
		timeout: 0

module.exports = VMAPClient