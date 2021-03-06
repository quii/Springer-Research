db = require('./../server-coffee/tag-provider-mongo')
tagProvider = new db.TagProvider('localhost', 27017)

exports.index = (req, res) ->
	res.render('index', { title: 'Express' })

exports.indexPost = (req, res) ->
	console.log("researching #{req.body.research.area}")
	res.redirect("/research/#{req.body.research.area.trim()}")

exports.research = (req, res) ->
	console.log("get to research #{req.params.area}")
	res.render('research_area', { area: req.params.area })

exports.postTag = (req, res) ->
	tagProvider.insert(req.body, (success, json) =>
		res.json(success: success, json: json)
	)

exports.researchGetTags = (req, res) ->
	tagProvider.getByTag(req.params.area, (doc) ->
		res.send(doc)
	)