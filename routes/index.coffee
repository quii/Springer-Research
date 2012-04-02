exports.index = (req, res) ->
  res.render('index', { title: 'Express' })

exports.research = (req, res) ->
  res.render('research_area', { area: req.params.area })