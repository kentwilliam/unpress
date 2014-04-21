component 'Reader',
  componentDidUpdate: ->
    node = @getDOMNode()
    node.children[0].innerHTML = @props.content
    node.scrollTop = 0

  render: ->
    (dom.div className: 'reader', children: [
      (dom.div className: 'content')
    ])
