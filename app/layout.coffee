component 'Layout',
  getInitialState: ->
    feeds: []
    readerUrl: null

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
    @setState
      readerUrl: event.currentTarget.getAttribute 'href'
    false

  render: ->
    dom.div
      className: 'layout'
      children: [

        (dom.nav className: '', children: [
          (dom.h1 children: 'Webcalm')
        ])

        (dom.div className: 'reader', children: @reader())

        (dom.div className: 'feeds', children: @feeds())
      ]

  reader: ->
    return unless @state.readerUrl?

    (dom.iframe src: @state.readerUrl)
