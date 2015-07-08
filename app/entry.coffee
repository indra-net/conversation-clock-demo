$ = require 'jquery'
docReady = require 'doc-ready'
audioContext = require 'audio-context'
microphoneManager = require './modules/MicrophoneManager/index.coffee'
getLoudestMicStream = require './modules/LoudestMicStream.coffee'
shareData = require './modules/shareData.coffee'
# views
joinConvoView = require './views/JoinConvoView.coffee'
convoViz = require './views/ConvoViz.coffee'

init = ->

	$body 			= $(document.body)
	$body.html		'<h2>share your microphone!</h2>'

	# request microphone access
	# cb is executed when we have a stream of mic amplitudes
	microphoneManager audioContext, (amplitudesStream) => 
		# join convo view
		# the cb is executed when user selects a color + hits join
		joinConvoView (color) => 
			shareData(color, amplitudesStream)
			loudestMicStream = getLoudestMicStream()
			convoViz(loudestMicStream)
		
	return 0

# launch the app when the document is ready
docReady init