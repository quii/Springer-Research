class Tagger
	constructor: ->
		@registerTagButtons()
		@getTaggedDocuments()
		@socketSupport = new SocketSupport()
		@listenForTagAdded()

	registerTagButtons: ->
		$(".tag").live("click", (event) =>

			tagData = 
				doi: $(event.currentTarget).attr 'doi'
				title: $(event.currentTarget).attr 'title'
				area: $(event.currentTarget).attr 'area'

			@socketSupport.sendSocketData('addTaggedDocument', tagData)
			
			$.ajax
				type: 'POST'
				data: tagData
				url: '/tag'
			
			return false
		)
		
	getTaggedDocuments: ->
		areaName = $("#area-id").text()
		url = "/tag/#{areaName}"
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
			console.log("got some data added", data)
			$("#tagged-container ol").append("<li><a href='http://rd.springer.com/#{data.doi}'>#{data.title}</a></li>")
		)

tagger = new Tagger()