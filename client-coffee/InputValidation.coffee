alphanumericRegex = "/[^a-zA-Z\d ]/g"

isFieldEmpty = (element) ->
	element.val().length==0

$.validator.addMethod(
	"regex"
	(value, element, regexp) ->
		re = new RegExp(regexp)
		return this.optional(element) || re.test(value)
	"Please check your input"
)

console.log("added validator method")