# Protoytpe widget

$ = require 'jquery'

# Load the style sheet as a string.
# This is processed by the gulp brfs transform at build time.
fs = require 'fs'
css = fs.readFileSync 'lib/proto/styles/proto.css'
$('style:first').append css

template = require '../views/proto.hbs'

render = (selector, data) ->
  console.log "render"
  html = template(data or {})
  $(selector).html html

window.SSW = {} unless window.SSW
window.SSW.proto = render


