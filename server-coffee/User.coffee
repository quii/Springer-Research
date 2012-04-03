root = exports ? this

class root.User
	constructor: (@socket) ->
		@name = uniqueId()
		@location = "home"
		@socket.set('name', @name)
	
	uniqueId =  ->
  		id = ""
  		id += Math.random().toString(36).substr(2) while id.length < 8
  		id.substr 0, 8

  	setUrl = (url) -> @url = url

  	@findUser = (users, userName) ->
  		results = (users.filter (user) -> user.name==userName)
  		results[0]

  	@currentLocations = (users) ->
  		(u.location) for u in users

  	@currentResearch = (users) ->
  		currentAreas = {}
  		for u in users when u.location!='home'
  			currentAreas[u.location] = 1
  		currentAreas