class Home
	constructor: ->
		@socketSupport = new SocketSupport()
		@currentResearch = []
		@askForRealtimeInfo()
		@listenForNewAreasBeingResearched()
		@tellServerImHome()

	askForRealtimeInfo: ->
		@socketSupport.sendRecieveData("whatsBeingResearched", {}, @displayCurrentResearch)

	tellServerImHome: -> @socketSupport.sendSocketData("whereAmI", "home")

	listenForNewAreasBeingResearched: ->
		@socketSupport.listen("newResearchHappening", @displayCurrentResearch)

	displayCurrentResearch: (data) =>
		console.log("data recieved = ", data)
		areas = []
		for key, val of data
			areas.push({name: key, number: val})

		if areas.length>0
			@currentResearch =
				results: areas

			renderedHTML = Mustache.to_html($('#current-research-template').html(), @currentResearch)
			$('#current-research-container').html(renderedHTML)
		else
			$('#current-research-container').html('') 

$ ->
	if($("#isHome").length>0)
		home = new Home()
