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