class SocketSupport
	constructor: -> @socket = io.connect('http://ec2-184-73-142-156.compute-1.amazonaws.com');

	listen: (name, callback) -> @socket.on(name, (data) -> callback(data))

	sendSocketData: (name, data) -> @socket.emit(name, data)

	sendRecieveData: (name, data, callback) ->
		@socket.emit(name, data, (recievedData) -> callback(recievedData))
