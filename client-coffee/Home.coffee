class Home
	constructor: ->
		@socketSupport = new SocketSupport()
		@currentResearch = []
		@askForRealtimeInfo()

	askForRealtimeInfo: ->
		console.log()
		@socketSupport.sendRecieveData("whatsBeingResearched", {}, @displayCurrentResearch)

	displayCurrentResearch: (data) =>
		areas = []
		for key, val of data
			areas.push({name: key, number: val})

		@currentResearch =
			results: areas

		renderedHTML = Mustache.to_html($('#current-research-template').html(), @currentResearch)
		$('#current-research-container').html(renderedHTML) 

$ ->
	if($("#isHome").length>0)
		home = new Home()
