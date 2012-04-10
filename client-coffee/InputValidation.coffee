isFieldEmpty = (element) ->
	element.val().length==0

$.validator.addMethod(
	"regex"
	(value, element, regexp) ->
		re = new RegExp(regexp)
		return this.optional(element) || re.test(value)
	"No shenanigans please (A-Z 0-9 with spaces only)"
)

addAlphaNumericValidation = (element) ->
	element.rules("add", { regex: "^[a-zA-Z0-9\\s]{1,40}$" })