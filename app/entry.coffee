docReady = require 'doc-ready'
audioContext = require 'audio-context'
Freezer = require 'freezer-js'
microphoneManager = require './modules/MicrophoneManager/index.coffee'
Kefir = require 'kefir'
$ = require 'jquery'
_ = require 'lodash'
postJson = require 'post-json-nicely'
Pusher = require 'pusher-js'

# get faucet for our app
faucet = () -> new Pusher('d5d9a0bbf3ee745375ba', encrypted:true).subscribe('everything')
# subscribes to loudest readings on the pubsub & calls emitter.emit on each value it gets
subscribeLoudestReadings = (emitter) -> faucet().bind('loudestMicrophoneReading', emitter.emit)

postAmplitude = (amp) ->
	# dummmy user config for now
	userConfiguration = {name:'nick', color:'#fe0fe0'}
	json = _.extend userConfiguration, {amplitude: amp, type: 'microphoneAmplitude'}
	postJson $, 'http://indra.webfactional.com/', json

init = ->

	# get amplitudes from the microphone
	amplitudesStream = new Kefir.pool()
	microphoneManager audioContext, (stream) => 
		amplitudesStream.plug(stream)

	# start posting amplitudes to the server
	amplitudesStream.throttle(300).onValue(postAmplitude)

	# subscribe to 'loudestMicrophoneReading' from the pubsub
	# color background everytime a loudest mic value comes in
	loudestMicStream 	= Kefir.stream(subscribeLoudestReadings)
	changeBackground 	= (color) -> $(document.body).css('background-color', color)
	loudestMicStream.onValue (data) -> changeBackground(data.color)

	# TODO
	# setupSelectionScreen amplitudeStream, (userConfiguration) ->
		# faucet = ...
		# amplitudeStream.onValue (amp) ->
		# setupVisualizer faucet

	return 0

# launch the app when the document is ready
docReady init