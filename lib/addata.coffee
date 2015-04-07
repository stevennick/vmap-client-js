# ADData represents real ad response, either actual content or ad URL for extenal ad server response.
class ADData
	constructor: ->

		# This value is paired with AdData array. Type will be stored as one of those values:
		# 
		# "AdTagURI": Regerence URL to get real ad response document (VAST 1.0~3.0)
		# "VASTAdData": A VAST 3.0 document
		# "CustomAdData-?": A ad response document that is not VAST-3.0. 
		#                   The question mark indicates response type; 
		#                   "CustomAdData-vast1" for VAST 1.0, 
		#                   "CustomAdData-vast2" for VAST 2.0, 
		#                   or proprietary values for custom response.
		@templateType = null
		# Actual data for this ad, either URL or context.
		@data = null

module.exports = ADData