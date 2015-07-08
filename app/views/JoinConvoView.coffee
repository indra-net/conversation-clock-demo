Kefir 	= require 'Kefir'
_ 		= require 'lodash'
$		= require 'jquery'

loginTemplate = () ->
	'''
	<input id="colorPicker" type="color"/>
	<button id = "joinConversationButton">Join!</button>
	'''

setup = (cb) ->

	$body 			= $(document.body)
	
	# setup the template
	$body.html loginTemplate()

	$joinButton 			= $ '#joinConversationButton'
	$colorPicker 			= $ '#colorPicker'
	
	# when join button is pressed,
	# call cb on the prodcuced config object
	$joinButton.on 'click', () ->
		color = $colorPicker.val()
		cb color

module.exports = setup