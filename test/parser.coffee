path = require 'path'
sys = require 'sys' # Debug only
chai = require 'chai'
expect = chai.expect
should = chai.should()
should

VMAPParser = require '../lib/parser'

puts = (obj) ->
  sys.puts(sys.inspect(obj))

urlFor = (relpath) ->
  return 'file://' + path.resolve(path.dirname(module.filename), relpath)


describe 'VMAPParser', ->
  describe '#parser', ->
    @options = {}
    @response = null
    _response = null
    # sys.puts(sys.inspect(urlFor('PlayerTestVMAP.xml')))

    before (done) =>
      VMAPParser.parse urlFor('PlayerTestVMAP.xml'), @options, (@response) =>
        _response = @response
        # puts _response
        done()

    after () =>
      # Do nothing

    it 'should not empty', =>
      @response.should.not.empty

    it 'should have four AdBreaks', =>
      @response.adbreaks.length.should.equal 4

    it 'should have correctly order', =>
      # Please note: Parsed id still in string type!
      adBreaks = @response.adbreaks
      adBreaks[0].id.should.equal "1"
      adBreaks[1].id.should.equal "2"
      adBreaks[2].id.should.equal "3"
      adBreaks[3].id.should.equal "4"

    describe 'adBreak', ->
      @adBreak = null

      before (done) =>
        @adBreak = _response.adbreaks[0]
        done()

      it 'breakType should equal linear', =>
        @adBreak.breakType.should.equal "linear"

      it 'breakId should equal mypre', =>
        @adBreak.breakId.should.equal "mypre"

      it 'timeOffset should be start', =>
        @adBreak.timeOffset.should.equal "start"

      it 'allowMultipleAds should be true', =>
        @adBreak.allowMultipleAds.should.equal true

      it 'followRedirects should be true', =>
        @adBreak.followRedirects.should.equal true

      it 'templateType should be vast3', =>
        @adBreak.templateType.should.equal "vast3"

      it 'if it is wrapper, adTagURI should exist but not vastAdData', =>
        if @adBreak.isWrapper
          @adBreak.vastAdData.should.not.exist
          @adBreak.adTagURI.should.exist

      it 'if it is not wrapper, vastAdData should exist but not adTagURI', =>
        if ! @adBreak.isWrapper
          @adBreak.vastAdData.should.exist
          adTagURI = @adBreak.adTagURI
          should.equal(adTagURI, null)

      # it 'sholud have tracking arrays if trackingEvents present', =>
      #   trackingEvent = @adBreak.trackingEvent
      #   if should.exist(trackingEvent)
      #     trackingEvent



