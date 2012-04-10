class SpringerLite

	constructor: ->
		@resultsCache = new SearchResultCache
		@handleSubmit()
		@handleLoadMore()
		@handleEmpty()
		loadMoreButton.hide()
		removeSavedSearchesButton.hide()

	doSearch: (page) ->
		searchButtonElement.attr("value", "Searching")
		@term = searchBox.val()

		if(@resultsCache.exists(@term))
			@renderResult(@term)
			loadMoreButton.show()
		else
			@getResult(@term)

	getResult: (term, page=1) ->
		page = parseInt(page)
		if(page==1)
			startIndex = 1
		else
			startIndex = page*10

		url = "http://api.springer.com/metadata/jsonp?q=#{term}&api_key=ueukuwx5guegu4ahjc6ajq8w&s=#{startIndex}&callback=?"
		console.log url
		$.ajax 
			url: url
			dataType: 'jsonp'
			type: 'GET'
			success: (json) => 
				searchButtonElement.attr("value", "Search")
				renderedHTML = Mustache.to_html($('#template').html(), json)
				@resultsCache.addResultToCache(term, renderedHTML)
				@renderResult(term)

	renderResult: (term) -> 
		resultsContainer.html(@resultsCache.getHtml(term))
		stitchResults()
		searchButtonElement.attr("value", "Search")
		loadMoreButton.text("Load more")
		loadMoreButton.show()
		removeSavedSearchesButton.show()

	handleSubmit: ->
		$("#search-form").submit (e) =>
			e.preventDefault() 
			if searchBox.val().length >0 then this.doSearch()

	handleLoadMore: ->
		loadMoreButton.click =>
			numberOfResultsOnPage = $("li").length-1
			nextPageNumber = (numberOfResultsOnPage/10)+1
			loadMoreButton.text("Loading more...")
			@getResult(@term, nextPageNumber)
			false

	handleEmpty: ->
		$("#empty-cache").click ->
			localStorage.clear()
			false

	stitchResults = ->
		numberOfLists = resultsContainer.find("ol").length
		if(numberOfLists>1)
			resultsContainer.find("li").each ->
				resultsContainer.find("ol:first").append($(this))
				resultsContainer.find("ol").not(":first").remove()


	loadMoreButton = do -> $("#load-more")
	removeSavedSearchesButton = do -> $("#empty-cache")
	searchButtonElement = do -> $("#search-button")
	resultsContainer = do -> $("#results")
	searchBox = do -> $("#search")

$ ->
	if($("#search").length>0)
		site = new SpringerLite()
		$("#search-form").validate()