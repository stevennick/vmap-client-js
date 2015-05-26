class VMAPUtil
  @options:
    test: false

  @parseBoolean: (string) ->
    bool = switch
      when string.toLowerCase() == 'true' then true
      when string.toLowerCase() == 'false' then false
    return bool if typeof bool == "boolean"
    return undefined

module.exports = VMAPUtil
