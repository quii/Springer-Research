root = exports ? this

class root.RealtimeResearchAreas

	constructor: ->
		@currentAreas = {}
	
	addUserToArea: (area) ->
		@currentAreas[area] = 1
		
	removeUserFromArea: (area) ->

	getUserCount: (area) ->
