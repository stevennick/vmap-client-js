path = require 'path'
sys = require 'sys' # Debug only
chai = require 'chai'
expect = chai.expect
chai.should()


{VMAPParser} = require '../lib/parser'

puts = (obj) ->
  sys.puts(sys.inspect(obj))

urlFor = (relpath) ->
  return 'file://' + path.resolve(path.dirname(module.filename), relpath)


describe 'VMAPParser', ->
  describe '#parser', ->
    @options = {"foo":"bar"}
    @response = null
    _response = null
    # sys.puts(sys.inspect(urlFor('PlayerTestVMAP.xml')))

    before (done) =>
      VMAPParser.parse urlFor('PlayerTestVMAP.xml'), @options, (@response) =>
        # puts @response
        _response = @response
        done()

    after () =>
      # Do nothing

    it 'should not empty', =>
      @response.should.not.empty

