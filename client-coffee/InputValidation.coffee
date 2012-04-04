class InputValidation
	@validate = (el) ->
		el.val(@replaceHTML(el.val()))

	@replaceHTML = (str) ->
		str.replace /[&<>"']/g, ($0) ->
    		"&" + {"&":"amp", "<":"lt", ">":"gt", '"':"quot", "'":"#39"}[$0] + ";"