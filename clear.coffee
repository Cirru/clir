
ll = console.log

available_lines = (lines) ->
  lines = lines.filter (x) ->
    return false if (x.match /^\s*$/)?
    return false if (x.match /^\s*\//)?
    return false if (x.match /^\s*\*\s/)?
    true

converter = (source) ->
  origin_source = available_lines source.split('\n')

  source = []
  for item, index in origin_source
    image = item.match /^\s*\\(.+)$/
    if image?
      source[source.length-1] += ', '+ image[1]
    else
      source.push item
  
  code = []

  detect_include = (item) ->
    image = item.match /^#include(.+)$/
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
    image = item.match /^(\s*\w+)\s+(.*)$/
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
    image = item.match /^([a-zA-Z]+):\s*(\w+)\s+<-\s+(.*)$/
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
    image = item.match /^(\s*[a-zA-Z]+):\s*((\w+,\s*)*\w+)$/
    if image?
      front = image[1]
      back = image[2]
      exp = "#{front} #{back};"
      code.push exp
      return true
    false

  detect_assign = (item) ->
    image = item.match /^(\s*[\w\.\[\]]+)\s*=\s*(.+)\s*$/
    if image?
      front = image[1]
      back = image[2]
      sub_image = back.match /^(\w+)\s*(\w+)$/
      if sub_image?
        back = "#{sub_image[1]} (#{sub_image[2]})"
      exp = "#{front} = #{back};"
      code.push exp
      return true
    false

  detect_mix_define = (item) ->
    image = item.match /^(\s*[a-zA-Z]+):\s*(\w+)\s*=\s*(.*)$/
    if image?
      front = image[1]
      middle = image[2]
      back = image[3]
      image_2 = back.match /^(\w+)\s+(\w+)$/
      if image_2?
        back = "#{image_2[1]} (#{image_2[2]})"
      exp = "#{front} #{middle} = #{back};"
      code.push exp
      return true
    false

  detect_bare_function = (item) ->
    image = item.match /(^\s+\w+)\s*$/
    if image?
      front = image[1]
      exp = "#{front} ();"
      code.push exp
      return true
    false

  detect_pre_define = (item) ->
    image = item.match /^([a-zA-Z]+):\s*(\w+)\s*=-\s*(.*)$/
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
    image = item.match /^(\s*\w+)\s*([+\-\*\/%]=)\s*(.*)$/
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
      (\w+)\s*
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

  detect_break_continue = (item) ->
    image = item.match /^(\s+(break)|(continue))\s*$/
    if image?
      exp = image[1] + ';'
      code.push exp
      return true
    false

  detect_struct = (item) ->
    image = item.match /^(\s*)\$\s*(\w+):\s*(\w+)?$/
    if image?
      spaces = image[1]
      name = image[2]
      defined = image[3]
      if defined?
        exp = "#{spaces}struct #{name} #{defined};"
      else
        exp = "#{spaces}struct #{name} {"
      code.push exp
      return true
    false

  detect_struct_f = (item) ->
    image = item.match /^(\s*)\$\s*(\w+):\s+(\w+)\s+<-(.*)$/
    if image?
      spaces = image[1]
      name = image[2]
      func = image[3]
      argv = image[4].replace(/:/g, ' ').replace(/\s+/g, ' ')
      exp = "#{spaces}struct #{name} #{func} (#{argv}){"
      code.push exp
      return true
    false

  detect_struct_assign = (item) ->
    image = item.match /^(\s*)\$\s*(\w+):\s+(\w+)\s*=(.+)$/
    if image?
      spaces = image[1]
      name = image[2]
      v_name = image[3]
      value = do image[4].trim
      sub_image = value.match /^(\w+)\s*(\w+)$/
      if sub_image?
        value = "#{sub_image[1]} (#{sub_image[2]})"
      exp = "#{spaces}struct #{name} #{v_name} = #{value};"
      code.push exp
      return true
    false

  detect_array_define = (item) ->
    image = item.match /^(\s*\w+):\s*(\w+)\s*#\s*(\w+)$/
    if image?
      head = image[1]
      vara = image[2]
      length = image[3]
      exp = "#{head} #{vara}[#{length}];"
      code.push exp
      return true
    false

  detect_array_mix = (item) ->
    image = item.match /^(\s*\w+):\s*(\w+)\s*((#\s*\w+\s*)+)=(.+)$/
    if image?
      head = image[1]
      vara = image[2]
      tmp = do image[3].trim
      length = ''
      sub_image = tmp.match /^#\s*(\w+)\s*(.*)/
      while sub_image?
        length += '[' + sub_image[1] + ']'
        sub_image = sub_image[2].match /^#\s*(\w+)\s*(.*)/

      back = do image[5].trim
      unless (back.match /".*"/)?
        back = '{ ' + back + ' }'
      else if (back.match /"\s*,\s*"/)?
        back = '{ ' + back + ' }'
      exp = "#{head} #{vara}#{length} = #{back};"
      code.push exp
      return true
    false

  detect_sharp_define = (item) ->
    image = item.match /^#define\s+/
    if image?
      code.push item
      return true
    false

  for item, index in source
    item = do item.trimRight
    continue if detect_array_define item
    continue if detect_array_mix item
    continue if detect_struct item
    continue if detect_struct_f item
    continue if detect_struct_assign item
    continue if detect_break_continue item
    continue if detect_forloop item
    continue if detect_if item
    continue if detect_self_do item
    continue if detect_else item
    continue if detect_switch item
    continue if detect_case item
    continue if detect_while item
    continue if detect_pre_define item
    continue if detect_bare_function item
    continue if detect_mix_define item
    continue if detect_assign item
    continue if detect_include item
    continue if detect_sharp_define item
    continue if detect_function item
    continue if detect_return item
    continue if detect_f_define item
    continue if detect_declare_type item
  
  code.push ''
  out = []
  struct_tag = off
  for index in [0...code.length-1]
    if (code[index].match /^\s*struct\s+.*{$/)?
      struct_tag = on
    current_indent = (code[index].match /^\s*/)[0].length
    next_indent = (code[index+1].match /^\s*/)[0].length
    n = (current_indent - next_indent) / 2
    if n>0
      spaces = (code[index].match /^\s+/)[0]
      out.push code[index]
      while n > 0
        spaces = spaces[0...-2]
        if struct_tag
          out.push spaces + '};'
          struct_tag = off
        else
          out.push spaces + '}'
        n -= 1
    else out.push code[index]
  out.join '\n'

exports.converter = converter if exports?
window.converter = converter if window?