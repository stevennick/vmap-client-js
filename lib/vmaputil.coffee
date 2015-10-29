class VMAPUtil

  @track: (URLTemplates, variables) ->
    if !URLTemplates?
      return
    URLs = @resolveURLTemplates(URLTemplates, variables)
    for URL in URLs
      if window?
        i = new Image()
        i.src = URL
      else
        # node mode, do not track (unit test only)

  @resolveURLTemplates: (URLTemplates, variables) ->
    URLs = []
    variables ?= {} # ["CACHEBUSTING", "random", "CONTENTPLAYHEAD", "ASSETURI", "ERRORCODE"]
    unless "CACHEBUSTING" of variables
      variables["CACHEBUSTING"] = Math.round(Math.random() * 1.0e+10)
    variables["random"] = variables["CACHEBUSTING"] # synonym for Auditude macro
    for URLTemplate in URLTemplates
      resolveURL = URLTemplate
      continue unless resolveURL
      for key, value of variables
        macro1 = "[#{key}]"
        macro2 = "%%#{key}%%"
        resolveURL = resolveURL.replace(macro1, value)
        resolveURL = resolveURL.replace(macro2, value)
      URLs.push resolveURL
    return URLs

  @parseBoolean: (string) ->
    bool = switch
      when string.toLowerCase() == 'true' then true
      when string.toLowerCase() == 'false' then false
    return bool if typeof bool == "boolean"
    return undefined

module.exports = VMAPUtil
