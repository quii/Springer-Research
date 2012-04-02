class SearchResultCache

	addResultToCache: (term, renderedHTML) -> 
		if @exists term
			localStorage.setItem(term, (@getHtml(term)+renderedHTML))
		else
			localStorage.setItem(term, renderedHTML)

	getHtml: (term) -> @findResult(term)

	exists: (term) -> @findResult(term)?

	findResult: (term) -> localStorage.getItem(term)

	keys: -> Object.keys(localStorage)