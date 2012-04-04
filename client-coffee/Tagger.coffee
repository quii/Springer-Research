class Tagger
	constructor: ->
		@areaName = $("#area-id").text()
		@registerTagButtons()
		@getTaggedDocuments()
		@socketSupport = new SocketSupport()
		@listenForTagAdded()

		@socketSupport.sendSocketData("whereAmI", @areaName)

	registerTagButtons: ->
		$(".tag").live("click", (event) =>

			tagData = 
				doi: $(event.currentTarget).attr 'doi'
				title: $(event.currentTarget).attr 'title'
				area: @areaName

			console.log("tag data = ", tagData)

			@socketSupport.sendSocketData('addTaggedDocument', tagData)
			
			$.ajax
				type: 'POST'
				data: tagData
				url: '/tag'
			
			return false
		)
		
	getTaggedDocuments: ->
		url = "/tag/#{@areaName}"
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

$ ->
	if($("#tagged-container").length>0)
		tagger = new Tagger()