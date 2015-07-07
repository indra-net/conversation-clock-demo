config = require  './config.js'
express = require 'express'
path = require 'path'
app = express()
server = require('http').Server(app);
bodyParser = require 'body-parser'
logger = require 'express-logger'
fs = require 'fs'
PusherClient = require('pusher-node-client').PusherClient
request = require 'request-json'
_ = require 'lodash'

delay = (t, cb) -> setTimeout cb, t
repeatedly = (interval, cb) -> setInterval cb, interval

# 
# http part
#
# express config
port = 3000
publicDir = "#{__dirname}/dist"
app.use(express.static(publicDir))
app.use(bodyParser.json())
# debug logger
app.use(logger({path: './logs/logfile.txt'}))

# ship webapp on /
read = 	(file) -> fs.createReadStream(path.join(publicDir, file))
app.get '/', (req, res) -> read('index.html').pipe(res)

# run server
server.listen(port)
console.log 'server listening on ' + port

#
# pusher part
#
# pusher config
pusherClient = new PusherClient
	appId: config.PUSHER_APP_ID
	key: config.PUSHER_KEY
	secret: config.PUSHER_SECRET
	encrypted: config.IS_PUSHER_ENCRYPTED

# a buffer for our microphone data
buffer = {}
# fn that adds data to buffer, 
# deletes data from buffer after 1 second
addToBuffer = (data) ->
	unixtime = Date.now()
	buffer[unixtime] = data
	# keep items in buffer for 1 second
	delay 1000, () -> delete buffer[unixtime]

# listen for microphone amplitude data
pusherClient.on 'connect', () ->
	sub = pusherClient.subscribe 'everything'
	# add mic data to the buffer
	sub.on 'microphoneAmplitude', addToBuffer

client = request.createClient 'http://indra.webfactional.com/' 
emitReading = (r) -> client.post '/', r, (err, res, body) ->
	if err then console.log 'err!', err
findLoudest = -> _.max buffer, (reading) -> reading.amplitude
# periodically emit the loudest reading in the buffer
repeatedly 300, () -> 
	loudest = findLoudest()
	loudest.type = 'loudestMicrophoneReading'
	emitReading loudest

# connect to pusher
pusherClient.connect()
