# Protoytpe widget

template = require '../views/proto.hbs'

html = template title: 'Prototype widget', body: 'Just a simple widget'
el = document.getElementById('proto-container')
el?.innerHTML = html
