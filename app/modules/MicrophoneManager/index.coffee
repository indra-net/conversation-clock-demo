connectStreamToScriptNode = (stream, audioctx) ->

	# create audiocontext stream from microphone stream
	microphone = audioctx.createMediaStreamSource stream
	# microphone -> analyzer
	analyzer = audioctx.createAnalyser()
	analyzer.fftSize = 1024;
	microphone.connect analyzer

	# TODO - setup compressor too
	# compressor = require('./makeCompressor.coffee') audioctx
	# microphone.connect compressor
	# compressor.connect(analyzer)
	# analyzer -> javascriptNode

	# javascriptNode gets average volume whenever 2048 frames have been sampled
	javascriptNode = audioctx.createScriptProcessor(2048, 1, 1);
	javascriptNode.onaudioprocess =  () ->
		# console.log 'being called!!!'
		array =  new Uint8Array(analyzer.frequencyBinCount)
		analyzer.getByteFrequencyData array
		console.log 'avg volume', require('./getAverageVolume.coffee') array
	analyzer.connect javascriptNode
	# hook javascript node to context
	javascriptNode.connect audioctx.destination
	
	return javascriptNode
	

setup = (microphoneStore, audioctx) ->

	# getUserMedia shim - get audio, 
	require('getusermedia') {audio: true, video: false}, (err, stream) ->

		# handle any error
		if err 
			microphoneStore.set 'error', err
			return 0

		# connect mic stream to a compressor
		scriptNode = connectStreamToScriptNode stream, audioctx
		# TODO - get a stream of amplitudes from the onaudioprocess callback

		# set streaming to true
		microphoneStore.set 'streaming', true
		return 0

module.exports = setup