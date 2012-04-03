root = exports ? this

class root.SocketHandler
	constructor: (@app) ->
		
		realtime = require('./RealtimeResearchAreas')
		@realtimeAreas = new realtime.RealtimeResearchAreas()

		io = require('socket.io').listen(@app)
		fs = require('fs')

		io.sockets.on('connection', (socket) =>

			socket.on('addTaggedDocument', (data) ->
				io.sockets.emit('taggedDocumentAdded', data)
			)

			socket.on('userInArea', (data) =>
				@realtimeAreas.addUserToArea(data)
				io.sockets.emit('newResearchHappening', @realtimeAreas.currentAreas)
			)

			socket.on('whatsBeingResearched', (from, f) =>
				f(@realtimeAreas.currentAreas)
			)
		)