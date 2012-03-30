
ll = console.log

available_lines = (lines) ->
  lines = lines.filter (x) ->
    if (x.match /^\s*$/)? then false else true

converter = (source) ->
  source = available_lines source.split('\n')
  source.unshift('')
  source.push('')
  
  code = []
  for item in source
    code.push item

  code.join '\n'

exports.converter = converter if exports?
window.converter = converter if window?