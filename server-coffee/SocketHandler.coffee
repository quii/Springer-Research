root = exports ? this

class root.SocketHandler
	constructor: (@app) ->
		
		userLib = require('./User')
		
		@users = []

		io = require('socket.io').listen(@app)
		fs = require('fs')

		io.sockets.on('connection', (socket) =>

			newUser = new userLib.User(socket)
			@users.push newUser

			socket.on('addTaggedDocument', (data) ->
				io.sockets.emit('taggedDocumentAdded', data)
			)

			socket.on('whereAmI', (data) =>
				socket.get('name', (err, name) =>
					userToUpdate = userLib.User.findUser(@users, name)
					userToUpdate.location = data
					io.sockets.emit('newResearchHappening', userLib.User.currentResearch(@users))
				)
			)

			socket.on('whatsBeingResearched', (from, f) =>
				f(userLib.User.currentResearch(@users))
			)

			socket.on('disconnect', =>
				socket.get('name', (err, name) =>
					@users = (@users.filter (user) -> user.name!=name)
					io.sockets.emit('newResearchHappening', userLib.User.currentResearch(@users))
				)
			)
		)