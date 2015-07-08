Kefir = require 'kefir'
Pusher = require 'pusher-js'

# group visualization
faucet = () -> new Pusher('d5d9a0bbf3ee745375ba', encrypted:true).subscribe('everything')
# subscribes to loudest readings on the pubsub & calls emitter.emit on each value it gets
loudestReadingEvents = (emitter) -> faucet().bind('loudestMicrophoneReading', emitter.emit)

# subscribes to view events and returns a stream of them
loudestMicStream = () ->
	# subscribe to 'loudestMicrophoneReading' from the pubsub
	Kefir.stream loudestReadingEvents 

module.exports = loudestMicStream