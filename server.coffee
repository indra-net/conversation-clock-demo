express = require 'express'
path = require 'path'
app = express()
server = require('http').Server(app);

port = 3000
publicDir = "#{__dirname}/dist"
app.use(express.static(publicDir))

# HTTP routes
server.listen(port)
app.get("/", (req, res) ->
	res.sendFile(
		path.join(publicDir, 'index.html')))

console.log 'server listening on ' + port
