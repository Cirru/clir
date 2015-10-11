
var write $ \ (state tree)
  cond (is (typeof tree) :string)
    state.update :code $ \ (code)
      + code (convertValue tree)
    case (tree.get 1)
      :#include $ exports.include state tree
      :int $ exports.int state tree
      :float $ exports.float state tree
      :char $ exports.char state tree
      :string $ exports.string state tree
      := $ exports.assign state tree
      ::: $ exports.type state tree
      else $ exports.notHandled state tree

var convertValue $ \ (token)
  case true
    (? $ token.match /^-?[\d\.]+$) token
    (? $ token.match /^:) $ JSON.stringify $ token.substr 1
    else token

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

= exports.float $ \ (state tree)
  var first $ tree.get 0
  state.update :code $ \ (code)
    + code ":float " first :[]

= exports.assign $ \ (state tree)
  var leftValue $ tree.get 0
  var rightValue $ tree.get 2
  var state1 $ exports.write state leftValue
  var state2 $ state1.update :code $ \ (code)
    + code ": = "
  var state3 $ exports.write state2 rightValue
  state3.update :code $ \ (code)
    + code :;

= exports.return $ \ (state tree)
  var first $ tree.get 0
  var state1 $ state.update :code $ \ (code)
    + code ":return "
  var state2 $ exports.write state1 tree
  state2.update :code $ \ (code)
    + code :;

= exports.notHandled $ \ (state tree)
  state.update :code $ \ (code)
    + code ":/* not" (JSON.stringify tree) ":handled */"

= exports.func $ \ (state tree)

= exports.type $ \ (state tree)
  var funcName $ tree.get 0
  var argTypes $ tree.get 2
  var returnType $ tree.get 3
  state.update :types $ \ (types)
    types.set funcName $ {}
      :arguments argTypes
      :return returnType
