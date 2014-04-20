class Application
  constructor: ->
    React.renderComponent Layout(), document.body

document.addEventListener 'DOMContentLoaded', ->
  new Application()

