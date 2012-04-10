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
		areas = []
		for key, val of data
			areas.push({name: key, number: val})

		if areas.length>0
			@currentResearch =
				results: areas

			renderedHTML = Mustache.to_html($('#current-research-template').html(), @currentResearch)
			currentResearchContainer.html(renderedHTML)
		else
			currentResearchContainer.html('') 

	researchAreaInput = do -> $("#research-area-input")
	currentResearchContainer = do -> $("#current-research-container")

$ ->
	if($("#isHome").length>0)
		home = new Home()
		$("form.home").validate()
		$("#research-area-input").rules("add", { regex: "^[a-zA-Z0-9\\s]{1,40}$" })
