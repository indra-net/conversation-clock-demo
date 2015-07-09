$	= require 'jquery'

reading = (amplitude, color) ->
	return $('<div class = "reading"></div>')
		.css('background-color', color)
		.css('width', amplitude*5+'px')
		.css('height', '3px')

setup = (loudestMicStream) ->
	
	$body 		= $(document.body)
	addReading 	= (r) -> $body.prepend(reading(r.amplitude, r.color))

	# add a reading a loudest mic value comes in
	loudestMicStream.onValue((r) -> addReading(r))

	# clear the body html to begin
	$body.html('')

module.exports = setup