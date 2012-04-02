express = require('express')
routes = require('./routes')
tagProvider = require('./server-coffee/tag-provider-mongo').TagProvider;

app = module.exports = express.createServer()

app.configure ->
  app.set('views', __dirname + '/views')
  app.set('view engine', 'jade')
  app.use(express.bodyParser())
  app.use(express.methodOverride())
  app.use(app.router)
  app.use(express.static(__dirname + '/public'))

app.configure('development', ->
  app.use(express.errorHandler({ dumpExceptions: true, showStack: true }))
)

app.configure('production', ->
  app.use(express.errorHandler())
)

app.get('/', routes.index)
app.get('/research/:area', routes.research)
app.post('/tag', routes.postTag)

app.listen(3000)