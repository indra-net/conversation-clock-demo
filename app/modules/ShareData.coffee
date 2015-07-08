postJson = require 'post-json-nicely'
$ = require 'jquery'

# data sharing
postReading = (json) -> postJson $, 'http://indra.webfactional.com/', json
# samples myAmplitudeStream and posts data. returns nothing.
shareData = (myColor, myAmplitudeStream) ->
	post = (a) -> postReading 
		type: 'microphoneAmplitude'
		amplitude: a
		color: myColor
	myAmplitudeStream.throttle(500).onValue post 

module.exports = shareData