
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
      target_code = f_head + ' (' + f_argv + ');'
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

  detect_f_define = (item) ->
    image = item.match /^([a-zA-Z]+):\s*([a-zA-Z_]+)\s+<-\s+(.*)$/
    if image?
      front = image[1]
      middle = image[2]
      back = image[3]
      define_sentence = "#{front} #{middle} (#{back}){"
      exp = define_sentence.replace /:/g, ' '
      code.push exp
      return true
    false

  detect_declare_type = (item) ->
    image = item.match /^(\s*[a-zA-Z]+):\s*(([a-zA-Z_]+,\s*)*[a-zA-Z_]+)$/
    if image?
      front = image[1]
      back = image[2]
      exp = "#{front} #{back};"
      code.push exp
      return true
    false

  detect_assign = (item) ->
    image = item.match /^(\s*[a-zA-Z_]+)\s*=\s*(.*)$/
    if image?
      front = image[1]
      back = image[2]
      exp = "#{front} = #{back};"
      code.push exp
      return true
    false

  detect_mix_define = (item) ->
    image = item.match /^(\s*[a-zA-Z]+):\s*([a-zA-Z_]+)\s*=\s*(.*)$/
    if image?
      front = image[1]
      middle = image[2]
      back = image[3]
      exp = "#{front} #{middle} = #{back};"
      code.push exp
      return true
    false

  detect_bare_function = (item) ->
    image = item.match /(^\s+[a-zA-Z_]+)\s*$/
    if image?
      front = image[1]
      exp = "#{front} ();"
      code.push exp
      return true
    false

  detect_pre_define = (item) ->
    image = item.match /^([a-zA-Z]+):\s*([a-zA-Z_]+)\s*=-\s*(.*)$/
    if image?
      front = image[1]
      middle = image[2]
      back = image[3]
      exp = "#{front} #{middle} (#{back});".replace /:/g, ' '
      code.push exp
      return true
    false

  detect_if = (item) ->
    image = item.match /^(\s*(else\s*)?if)\s+(.*)$/
    if image?
      head = image[1]
      body = image[3]
      exp = "#{head} (#{body}){"
      code.push exp
      return true
    false

  detect_else = (item) ->
    image = item.match /^(\s*else)\s*$/
    if image?
      head = image[1]
      code.push head + ' {'
      return true
    false

  detect_switch = (item) ->
    image = item.match /^(\s*switch)\s*(.*)\s*$/
    if image?
      head = image[1]
      body = image[2]
      exp = "#{head} (#{body}){"
      code.push exp
      return true
    false

  detect_case = (item) ->
    image = item.match /^((\s*)case)\s*(.*)\s*$/
    if image?
      lastline = code[-1..-1][0]
      look_back = lastline.match /^\s*switch/
      unless look_back?
        code.push "#{image[2]}  break;"
      head = image[1]
      body = image[3]
      if body.length is 0
        exp = "#{image[2]}default:{"
      else
        exp = "#{head} #{body}:{"
      code.push exp
      return true
    false

  detect_default = (item) ->
    image = item.match /^(\s*default)\s*$/
    if image?
      exp = image[1] + ':{'
      code.push exp
      return true
    false

  detect_while = (item) ->
    image = item.match /^(\s*while)\s+(.*)$/
    if image?
      head = image[1]
      body = image[2]
      exp = "#{head} (#{body}){"
      code.push exp
      return true
    false

  detect_self_do = (item) ->
    image = item.match /^(\s*[a-zA-Z_]+)\s*([+\-\*\/%]=)\s*(.*)$/
    if image?
      front = image[1]
      middle = image[2]
      back = image[3]
      exp = "#{front} #{middle} #{back};"
      code.push exp
      return true
    false

  detect_forloop = (item) ->
    image = item.match ///^
      (\s*for)\s+
      ([a-zA-Z_]+)\s*
      <-\s*
      (.+)
      ,\s*
      (.+)\.\.
      \s*
      (.+)
      $///
    if image?
      head = image[1]
      v = image[2]
      from = image[3]
      succ = image[4]
      impr = succ - from
      last = image[5]
      v_exp = "#{head[0...-3]}int #{v};"
      exp = "#{head} (#{v}=#{from}; #{v}<=#{last}; #{v}+=#{impr}){"
      code.push v_exp
      code.push exp
      return true
    false

  for item, index in source
    item = do item.trimRight
    continue if detect_forloop item
    continue if detect_if item
    continue if detect_self_do item
    continue if detect_else item
    continue if detect_switch item
    continue if detect_default item
    continue if detect_case item
    continue if detect_while item
    continue if detect_pre_define item
    continue if detect_bare_function item
    continue if detect_mix_define item
    continue if detect_assign item
    continue if detect_include item
    continue if detect_function item
    continue if detect_return item
    continue if detect_f_define item
    continue if detect_declare_type item
  
  code.push ''
  out = []
  for index in [0...code.length-1]
    current_indent = (code[index].match /^\s*/)[0].length
    next_indent = (code[index+1].match /^\s*/)[0].length
    n = (current_indent - next_indent) / 2
    if n>0
      spaces = (code[index].match /^\s+/)[0]
      out.push code[index]
      while n > 0
        spaces = spaces[0...-2]
        out.push spaces + '}'
        n -= 1
    else out.push code[index]
  out.join '\n'

exports.converter = converter if exports?
window.converter = converter if window?