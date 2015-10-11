
var
  parser $ require :cirru-parser
  Immutable $ require :immutable

var
  syntax $ require :./syntax

var bind $ \ (v k) (k v)

var
  initialState $ Immutable.fromJS $ {}
    :indentation :
    :code :
    :types $ {}

var writeProgram $ \ (state tree)
  var
    result $ tree.reduce
      \ (acc exp)
        bind
          syntax.write
            acc.update :code $ \ (code)
              + code ":\n"
            , exp
          \ (newState)
            newState.update :code $ \ (code)
              + code ":\n"
      , state
  result.get :code

= exports.transform $ \ (source)
  var
    ast $ parser.pare source :runtime
  writeProgram initialState
    Immutable.fromJS ast
