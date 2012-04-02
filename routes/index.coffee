exports.index = (req, res) ->
  res.render('index', { title: 'Express' })

exports.research = (req, res) ->
  res.render('research_area', { area: req.params.area })

exports.postTag = (req, res) ->
	console.log("recieving tag to post", req.body)
	"done"