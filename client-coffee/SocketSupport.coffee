class SocketSupport
	constructor: -> @socket = io.connect('http://localhost');

	listen: (name, callback) -> @socket.on(name, (data) -> callback(data))

	sendSocketData: (name, data) -> @socket.emit(name, data)
