VMAPParser = require './parser.coffee'
VMAPUtil = require './vmaputil.coffee'

class VMAPClient
  @options:
    withCredentials: true,
    timeout: 0

  @get: (url, opts, cb) ->

    extend = exports.extend = (object, properties) ->
      for key, val of properties
          object[key] = val
      object

    if not cb
        cb = opts if typeof opts is 'function'
        options = {}

    options = extend @options, opts

    VMAPParser.parse url, options, (response) =>
      cb(response)

module.exports = VMAPClient
