alphanumericRegex = "/[^a-zA-Z\d ]/g"

regexFunction = (value, element, regexp) ->
	re = new RegExp(regexp)
	return re.test(value)


$.validator.addMethod("regex", regexFunction, "Please check your input")

validateAlphanumeric = (el) -> el.rules("add", regex: alphanumericRegex)