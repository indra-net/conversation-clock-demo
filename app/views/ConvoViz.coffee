$	= require 'jquery'

reading = (amplitude, color) ->
	div = $('<div class = "reading"></div>')
		.css('background-color', color)
		.css('width', amplitude*100+'px')
		.css('height', '100px')
	console.log div
	div

setup = (loudestMicStream) ->
	
	$body 			= $(document.body)

	# add a reading a loudest mic value comes in
	addReading = (r) -> $body.append reading(r.amplitude, r.color)
	loudestMicStream.onValue addReading

	# clear the body html to begin
	$body.html ''

module.exports = setup