Array::remove = (e) -> @[t..t] = [] if (t = @indexOf(e)) > -1

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

			$(event.currentTarget).hide()

			tagData = 
				doi: $(event.currentTarget).attr 'doi'
				title: $(event.currentTarget).attr 'title'
				areas:[@areaName]
			
			$.ajax
				type: 'POST'
				data: tagData
				url: '/tag'
				success: (json) =>
					if json.success
						@socketSupport.sendSocketData('addTaggedDocument', json.json)
					else 
						alert("Didn't add tag, soz pal. It's probably already tagged.")
			
			return false
		)

	getTaggedDocuments: ->
		url = "/tag/#{@areaName}"
		$.ajax
			url: url
			dataType: 'json'
			type: 'GET'
			success: (json) => renderTaggedDocuments(json)

	renderTaggedDocuments = (json) =>
			renderedHTML = Mustache.to_html($('#tagged-template').html(), json)
			$('#tagged-container').html(renderedHTML)
			derp = $("#area-id").text()
			$('#tagged-container').find(".also-tagged li").remove(":contains('#{derp}')");

			if json.results.length is 0 then $('#tagged-container').hide()

	listenForTagAdded: ->
		@socketSupport.listen('taggedDocumentAdded', (data) =>
			console.log("data = ", data)
			if @areaName in data.areas
				$('#tagged-container').show()
				$("#tagged-container ol").prepend @makeTagMarkup(data)
		)

	makeTagMarkup: (json) =>
		areaList = ""
		unless json.areas.length==1
			areaList = "<ul class='also-tagged'>"
			for area in json.areas
				unless area==@areaName then areaList+="<li><a href='/research/#{area}'>#{area}</a></li>"
			areaList+="</ul>"

		"<li><a href='http://rd.springer.com/#{json.doi}'>#{json.title}</a>#{areaList}</li>"

$ ->
	if($("#tagged-container").length>0)
		tagger = new Tagger()