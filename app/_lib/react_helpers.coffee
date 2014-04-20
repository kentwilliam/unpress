dom = React.DOM

appScope = this
component = (name, spec) ->
  appScope[name] = React.createClass _.assign spec, displayName: name
