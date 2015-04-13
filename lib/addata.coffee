# ADSource represents real ad response, either actual content or ad URL for extenal ad server response.
class ADSource
	constructor: ->

		@allowMultipleAds = false

		@followRedirects = false

		@id = null
		# This value is paired with AdData array. Type will be stored as one of those values:
		# 
		# "AdTagURI": Regerence URL to get real ad response document (VAST 1.0~3.0)
		# "VASTAdData": A VAST 3.0 document
		# "?": A ad response document that multiple format. 
		#                   The question mark indicates response type; 
		#                   "vast" for VAST 1.0
		#                   "vast1" for VAST 1.0.1, 
		#                   "vast2" for VAST 2.0, 
		#                   "vast3" for VAST 3.0
		#                   or proprietary values for custom response.
		@templateType = null
		# Actual data for this ad context, may be null.
		@vastAdData = null
		# 
		@adTagURI = null
		# indicate this data is URL wrapper or contain actual data.
		@isWrapper = false

module.exports = ADSource