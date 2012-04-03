class SocketSupport
	constructor: -> @socket = io.connect('http://localhost');

	listen: (name, callback) -> @socket.on(name, (data) -> callback(data))

	sendSocketData: (name, data) -> @socket.emit(name, data)

	sendRecieveData: (name, data, callback) ->
		@socket.emit(name, data, (recievedData) -> callback(recievedData))
