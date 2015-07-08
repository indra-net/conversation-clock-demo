getUserMedia = require('getusermedia')
Kefir = require('kefir')
getAverageVolume = require('./getAverageVolume.coffee')

microphoneAnalyzer = (stream, audioctx) ->
	microphone = audioctx.createMediaStreamSource stream
	# microphone -> analyzer
	analyzer = audioctx.createAnalyser()
	analyzer.fftSize = 1024;
	microphone.connect analyzer
	return analyzer

analyzerScriptNode = (analyzer, audioctx) ->
	# analyzer -> javascriptNode -> audioCtx
	# javascriptNode gets average volume whenever 1024 frames have been sampled
	javascriptNode = audioctx.createScriptProcessor(1024, 1, 1);
	analyzer.connect javascriptNode
	javascriptNode.connect audioctx.destination
	return javascriptNode

averageAmplitudesStream = (scriptNode, analyzerNode) ->
	return Kefir.stream (emitter) ->
		scriptNode.onaudioprocess =  () ->
			# console.log 'being called!!!'
			array =  new Uint8Array(analyzerNode.frequencyBinCount)
			analyzerNode.getByteFrequencyData array
			emitter.emit getAverageVolume array

microphoneAmplitudesStream = (stream, audioctx) ->
	analyzer = microphoneAnalyzer stream, audioctx
	scriptNode = analyzerScriptNode analyzer, audioctx
	return averageAmplitudesStream scriptNode, analyzer

# AudioContext -> err/void
setup = (audioctx, cb) ->
	# getUserMedia shim - get audio, 
	getUserMedia {audio: true, video: false}, (err, stream) ->
		# handle any error
		return err if err
		# get stream of amplitudes from microphone
		cb microphoneAmplitudesStream stream, audioctx

module.exports = setup