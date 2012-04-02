class Tagger
	constructor: ->
		@registerTagButtons()
		@getTaggedDocuments()

	registerTagButtons: ->
		$(".tag").live("click", ->

			tagData = 
				doi: $(this).attr('doi'),
				title: $(this).attr('title'),
				area: $(this).attr('area')
			
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

tagger = new Tagger()