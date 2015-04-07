class ADBreak
	constructor: ->
		# Types are "linear" or 
		@breakType = null
		# Values are "hh:mm:ss.mmm", "start", "end", "n%" within 0~100, or "#m" in minutes
		@timeOffset = null
		# Optional
		@breakId = null
		# ADSource
		# Optional
		@allowMultipleAds = false
		# Optional
		@followRedirects = true
		# Optional
		@id = null

		# Ad content, a AdData array.
		@adContent = []

		# URI for ad break tracking events. Null for non tracking
		@trackingStart = null
		@trackingEnd = null
		@trackingError = null

module.exports = ADBreak

