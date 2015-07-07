docReady = require 'doc-ready'
audioContext = require 'audio-context'
Freezer = require 'freezer-js'
microphoneManager = require './modules/MicrophoneManager/index.coffee'
Kefir = require 'kefir'
$ = require 'jquery'
_ = require 'lodash'
postJson = require 'post-json-nicely'

init = ->

	amplitudesStream = new Kefir.pool()
	microphoneManager audioContext, (stream) => amplitudesStream.plug stream 

	# TODO
	# setupSelectionScreen amplitudeStream, (userConfiguration) ->
		# faucet = ...
		# amplitudeStream.onValue (amp) ->
		# setupVisualizer faucet

	# dummmy user config for now
	userConfiguration = {name:'nick', color:'#fe0fe0'}

	amplitudesStream.throttle(300).onValue (amp) ->
		json = _.extend userConfiguration, {amplitude: amp}
		json = _.extend json, {'type': 'microphoneAmplitude'}
		postJson $, 'http://indra.webfactional.com/', json

	return 0


# launch the app when the document is ready
docReady init