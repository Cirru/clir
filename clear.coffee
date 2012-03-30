
ll = console.log

available_lines = (lines) ->
  lines = lines.filter (x) ->
    return false if (x.match /^\s*$/)?
    return false if (x.match /^\s*\//)?
    return false if (x.match /^\s*\*\s/)?
    true

converter = (source) ->
  source = available_lines source.split('\n')
  source.unshift('')
  source.push('')
  
  code = []

  detect_include = (item) ->
    image = item.match /^#include\s+([a-zA-Z_\-\.\s*]+)+$/
    if image?
      include_list = (image[1].trim().split ' ').filter (x) ->
        if x is '' then false else true
      for head_file in include_list
        if (head_file.indexOf '.') is -1
          code.push "#include \"#{head_file}.h\""
        else code.push "#include <#{head_file}>"
      return true
    false

  detect_function = (item) ->
    image = item.match /^([a-zA-Z_]+\*?:\s*&?\**[a-zA-Z_]+)/
    ll image

  for item, index in source[1...-1]
    continue if detect_include item
    continue if detect_function item

  code.join '\n'

exports.converter = converter if exports?
window.converter = converter if window?