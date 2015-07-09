$ = require 'jquery'
docReady = require 'doc-ready'
audioContext = require 'audio-context'
microphoneManager = require './modules/MicrophoneManager/index.coffee'
getLoudestMicStream = require './modules/LoudestMicStream.coffee'
publish = require './modules/ShareData.coffee'
# views
joinConvoView = require './views/JoinConvoView.coffee'
convoViz = require './views/ConvoViz.coffee'

init = ->

	$body 			= $(document.body)
	$body.html		'<h2>share your microphone!</h2>'

	# request microphone access
	# when we get access to the mic, we execute the callback on a stream of amplitudes from the microphone 
	microphoneManager audioContext, (amplitudesStream) => 
		# join convo view
		# the cb is executed when user selects a color + hits join
		joinConvoView (color) => 
			publish(color, amplitudesStream)
			loudestMicStream = getLoudestMicStream()
			convoViz(loudestMicStream)
		
	return 0

# launch the app when the document is ready
docReady init