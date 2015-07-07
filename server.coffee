config = require  './config.js'
express = require 'express'
path = require 'path'
app = express()
server = require('http').Server(app);
bodyParser = require 'body-parser'
logger = require 'express-logger'
fs = require 'fs'
PusherClient = require('pusher-node-client').PusherClient

# express config
port = 3000
publicDir = "#{__dirname}/dist"
app.use(express.static(publicDir))
app.use(bodyParser.json())
# debug logger
app.use(logger({path: './logs/logfile.txt'}))

# ship webapp on /
read = (file) -> fs.createReadStream(path.join(publicDir, file))
app.get '/', (req, res) -> read('index.html').pipe(res)

# pusher config
pusherClient = new PusherClient
	appId: config.PUSHER_APP_ID
	key: config.PUSHER_KEY
	secret: config.PUSHER_SECRET
	encrypted: config.IS_PUSHER_ENCRYPTED

# listen for microphone amplitude data
pusherClient.on 'connect', () ->
	sub = pusherClient.subscribe 'everything'
	sub.on 'microphoneAmplitude', (data) ->
		# TODO - find max 'max recently'
		console.log 'got data!', data
		# TODO - emit recent max via post req

# connect to pusher
pusherClient.connect()

# run server
server.listen(port)
console.log 'server listening on ' + port
