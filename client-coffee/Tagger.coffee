class Tagger
	constructor: ->
		@areaName = $("#area-id").text()
		@registerTagButtons()
		@getTaggedDocuments()
		@socketSupport = new SocketSupport()
		@listenForTagAdded()
		@tellServerImLookingAtTag()

	registerTagButtons: ->
		$(".tag").live("click", (event) =>

			tagData = 
				doi: $(event.currentTarget).attr 'doi'
				title: $(event.currentTarget).attr 'title'
				area: $(event.currentTarget).attr 'area'

			@socketSupport.sendSocketData('addTaggedDocument', tagData)

			console.log("posting tag data: #{tagData}")
			
			$.ajax
				type: 'POST'
				data: tagData
				url: '/tag'
			
			return false
		)
		
	getTaggedDocuments: ->
		url = "/tag/#{@areaName}"
		console.log("trying to get from #{url}")
		$.ajax
			url: url
			dataType: 'json'
			type: 'GET'
			success: (json) -> renderTaggedDocuments(json)

	renderTaggedDocuments = (json) ->
		renderedHTML = Mustache.to_html($('#tagged-template').html(), json)
		$('#tagged-container').html(renderedHTML)

	listenForTagAdded: ->
		@socketSupport.listen('taggedDocumentAdded', (data) ->
			$("#tagged-container ol").append("<li><a href='http://rd.springer.com/#{data.doi}'>#{data.title}</a></li>")
		)

	listenForWhosWhere: ->
		@socketSupport.listen('whosWhere', ->
			@tellServerImLookingAtTag
		)

	tellServerImLookingAtTag: ->
		@socketSupport.sendSocketData('userInArea', {@areaName})

$ ->
	if($("#tagged-container").length>0)
		tagger = new Tagger()