express = require 'express'
http = require 'http'
path = require 'path'

base = path.resolve '.'

app = express()
app.use express.static(base)
app.use express.json()
app.use express.logger('dev')
app.use express.urlencoded()

app.get '/api/:name', (req, res) ->
  res.json 200, 'hello': req.params.name

exports.start = (port) ->
  app.listen port, ->
    console.log 'ready, captain'

