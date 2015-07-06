docReady = require 'doc-ready'
audioContext = require 'audio-context'
Freezer = require 'freezer-js'
microphoneManager = require './modules/MicrophoneManager/index.coffee'

init = ->
	# app store
	store = new Freezer
	    microphone: 
	    	error: null
	    	streaming: false
	        # amplitudeStream: null
	    user: 
	        name: ''
	        color: ''

	microphoneManager store.get().microphone, audioContext

	store.on 'update', (state) ->
		console.log 'new state', state

	# console.log 'main app done+launched'


# launch the app when the document is ready
docReady init