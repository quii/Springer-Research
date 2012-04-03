root = exports ? this

class root.SocketHandler
	constructor: (@app) ->
		
		@realtimeAreas = require('./RealtimeResearchAreas').RealtimeResearchAreas()

		io = require('socket.io').listen(@app)
		fs = require('fs')

		io.sockets.on('connection', (socket) ->

			socket.on('addTaggedDocument', (data) ->
				io.sockets.emit('taggedDocumentAdded', data)
			)

			socket.on('userInArea', (data) ->
				#@realtimeAreas.addUserToArea(data)
			)

			socket.on('whatsBeingResearched', (from, f) ->
				areas = 
					"coffeescript": 2
					"apple": 3
				f(areas)
			)
		)