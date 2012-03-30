
ll = console.log

available_lines = (lines) ->
  lines = lines.filter (x) ->
    return false if (x.match /^\s*$/)?
    return false if (x.match /^\s*\//)?
    return false if (x.match /^\s*\*\s/)?
    true

converter = (source) ->
  source = available_lines source.split('\n')
  
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
    image = item.match /^(\s*[a-zA-Z_]+)\s+(.*)$/
    if image?
      f_head = image[1]
      f_argv = image[2]
      target_code = f_head + '(' + f_argv + ');'
      code.push target_code
      return true
    false

  detect_return = (item) ->
    image = item.match /^(\s+)=>\s*(.*)$/
    if image?
      before_return = image[1]
      after_return = image[2]
      return_sentence = before_return + 'return ' + after_return + ';'
      code.push return_sentence
      return true
    false

  detect_fdefine = (item) ->
    image = item.match /^([a-zA-Z]+:[a-zA-Z_]+)\s+::(\s+.*)$/
    if image?
      func_name = image[1]
      func_argv = image[2].trim()
      define_sentence = func_name + '(' + func_argv + '){'
      exp = define_sentence.replace /:/g, ' '
      code.push exp
      return true
    false

  detect_declare_type = (item) ->
    image = item.match /^(\s+[a-zA-Z]+):\s*(([a-zA-Z_]+,\s*)*[a-zA-Z_]+)$/
    if image?
      front = image[1]
      back = image[2]
      exp = front + ' ' + back + ';'
      code.push exp
      return true
    false

  for item, index in source
    item = do item.trimRight
    continue if detect_include item
    continue if detect_function item
    continue if detect_return item
    continue if detect_fdefine item
    continue if detect_declare_type item
  
  code.push ''
  out = []
  for index in [0...code.length-1]
    current_indent = (code[index].match /^\s*/)[0].length
    next_indent = (code[index+1].match /^\s*/)[0].length
    n = (current_indent - next_indent) / 2
    if n>0
      spaces = code[index].match /^\s+/
      out.push code[index]
      while n > 0
        out.push spaces[0...-2] + '}'
        n -= 1
    else out.push code[index]
  out.join '\n'

exports.converter = converter if exports?
window.converter = converter if window?