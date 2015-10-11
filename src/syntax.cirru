
var
  Immutable $ require :immutable

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
      :\ $ exports.func state tree
      :return $ exports.return state tree
      :+ $ exports.add state tree
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
  var state2 $ exports.write state1 first
  state2.update :code $ \ (code)
    + code :;

= exports.notHandled $ \ (state tree)
  state.update :code $ \ (code)
    + code ":/* not" (JSON.stringify tree) ":handled */"

= exports.func $ \ (state tree)
  var
    funcName $ tree.get 0
    args $ tree.get 2
    body $ tree.slice 3
    typeInfo $ state.getIn $ [] :types funcName
  if (not $ ? typeInfo) $ do
    throw $ + ":type anotations not found for: " funcName
  var argsCode $ ... args
    map $ \ (arg index)
      var itsType $ typeInfo.getIn $ [] :arguments index
      + itsType ": " arg
    join ":, "
  var state1 $ ... state
    update :code $ \ (code)
      + code (typeInfo.get :return) ": " funcName ":(" argsCode ":) {\n"
    update :indentation $ \ (indentation)
      + indentation ":  "
  var result $ ... body
    reduce
      \ (acc line)
        var acc1 $ acc.update :code $ \ (code)
          + code (acc.get :indentation)
        var acc2 $ exports.write acc1 line
        acc2.update :code $ \ (code)
          + code ":\n"
      , state1
  ... result
    update :code $ \ (code)
      + code ":}"
    update :indentation $ \ (indentation)
      indentation.substr 2

= exports.type $ \ (state tree)
  var funcName $ tree.get 0
  var argTypes $ tree.get 2
  var returnType $ tree.get 3
  state.update :types $ \ (types)
    types.set funcName $ Immutable.fromJS $ {}
      :arguments argTypes
      :return returnType

= exports.add $ \ (state tree)
  var leftValue $ convertValue $ tree.get 0
  var rightValue $ convertValue $ tree.get 2
  state.update :code $ \ (code)
    + code leftValue ": + " rightValue
