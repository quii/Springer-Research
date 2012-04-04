class InputValidation
	@validate = (el) ->
		
		#el.val(@replaceHTML(el.val()))

		#str = el.val().trim()

		#@noFunnyChars(str)

		#if @isEmptyString(str) then return false

		return true

	@replaceHTML = (str) ->
		str.replace /[&<>"']/g, ($0) ->
    		"&" + {"&":"amp", "<":"lt", ">":"gt", '"':"quot", "'":"#39"}[$0] + ";"

    @noFunnyChars = (str) ->
    	pattern = /^([a-zA-Z0-9,-]|\s)*$/
    	console.log pattern.test(str)

	@isEmptyString = (s) ->
	  return true if s instanceof String and s.length == 0
	  s == ''