
var write $ \ (state tree)
  var func $ tree.get 1
  case func
    :#include $ exports.include state tree
    :int $ exports.int state tree
    :char $ exports.char state tree
    :string $ exports.string state tree
    else state

= exports.write write

= exports.include $ \ (state tree)
  var first $ tree.get 0
  state.update :code $ \ (code)
    + code ":#include <" first :>

= exports.int $ \ (state tree)
  var first $ tree.get 0
  state.update :code $ \ (code)
    + code ":int " first

= exports.char $ \ (state tree)
  var first $ tree.get 0
  state.update :code $ \ (code)
    + code ":char " first

= exports.string $ \ (state tree)
  var first $ tree.get 0
  state.update :code $ \ (code)
    + code ":char " first :[]

= (. exports :=) $ \ (state first rest)
