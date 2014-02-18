assert = require 'assert'
fs = require 'fs'

describe 'blueprint parser', ->
	parser = require '../lib/blueprintParser'
	input = fs.readFileSync 'test/examples/1. Simplest API.md', 'utf8'

	it 'returns a JSON object', ->
		result = parser.parse ''
		assert.equal typeof result, 'object'

	it 'parses a version number', ->
		result = parser.parse ''
		assert.equal result._version, "1.0"
		
	it 'takes input', ->
		result = parser.parse input
		console.log result
