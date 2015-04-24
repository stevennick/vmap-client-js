chai = require 'chai'
path = require 'path'
expect = chai.expect
should = chai.should()
should

{VMAPParser} = require '../lib/parser'
EventTracker = require '../lib/eventtracker'

urlFor = (relpath) ->
  return 'file://' + path.resolve(path.dirname(module.filename), relpath)


describe 'eventtracker', ->

  @options = {}
  @response = null
  _response = null
  @tracker = null

  before (done) =>
    VMAPParser.parse urlFor('PlayerTestVMAP.xml'), @options, (@response) =>
      _response = @response
      @tracker = new EventTracker(_response.eventTracker)
      # puts _response
      done()

  after () =>
    # Do nothing
    #
  it 'should have something', =>
    _response.should.not.empty
    @tracker.should.not.empty

