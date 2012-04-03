root = exports ? this

class root.SocketHandler
	constructor: (@app) ->
		
		io = require('socket.io').listen(@app)
		fs = require('fs')

		io.sockets.on('connection', (socket) ->

			socket.on('addTaggedDocument', (data) ->
				io.sockets.emit('taggedDocumentAdded', data)
			)
		)