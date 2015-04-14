should = require 'should'
path = require 'path'
VASTParser = require '../src/parser'

urlFor = (relpath) ->
	return 'file://' + path.resolve(path.dirname(module.filename), relpath)

describe 'VMAPParser', ->
	describe '#parse', ->
		@response = null
		_response = null

		before(done) =>
			VMAPParser.parse urlFor('test.xml'), (@response) =>
				_response = @response
				done()

		after () =>
			# Do nothing

		it 'should have called', =>
			1.sholud.equal 1