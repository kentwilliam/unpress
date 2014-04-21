component 'Layout',
  getInitialState: ->
    feeds: []
    readerContent: ''

  componentWillMount: ->
    oboe('/feeds.json').done (feeds) =>
      @setState feeds: feeds

  feeds: ->
    _.flatten @state.feeds.map (feed) =>
      feed.entries.map (entry) =>
        dom.a
          href: entry.url,
          onClick: @onFeedClick
          children: [
            (dom.b children: entry.title)
            (dom.i children: entry.preview)
          ]

  onFeedClick: (event) ->
    href = event.currentTarget.getAttribute 'href'
    oboe('/url/' + encodeURI(href)).done (result) =>
      @setState readerContent: result.content
    false

  render: ->
    dom.div
      className: 'layout'
      children: [
        (Reader content: @state.readerContent)
        (dom.div className: 'feeds', children:
          [
            (dom.h1 children: (dom.img src: '/raed-logo.svg'))
          ].concat @feeds())
      ]

