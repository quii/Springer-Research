db = require('./../server-coffee/tag-provider-mongo')
tagProvider = new db.TagProvider('localhost', 27017)

exports.index = (req, res) ->
  res.render('index', { title: 'Express' })

exports.research = (req, res) ->
  res.render('research_area', { area: req.params.area })

exports.postTag = (req, res) ->
	tagProvider.insert(req.body)
	"done"

exports.researchGetTags = (req, res) ->
	tagProvider.getByTag(req.params.area, (doc) ->
		res.send(doc)
	)