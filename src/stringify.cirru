
var
  Immutable $ require :immutable

var
  blank ": "
  newline ":\n"
  semicolon :;

= exports.write $ \ (ast)
  var initialState $ Immutable.fromJS $ {}
    :code newline
    :indentation :
  ... (write initialState ast) (get :code)

var bind $ \ (v k) (k v)

var write $ \ (state tree)
  bind
    case (tree.get :type)
      :program writeProgram
      :#include writeInclude
      :int writeInt
      :float writeFloat
      :char writeChar
      :string writeString
      else renderString
    \ (codeWriter) (codeWriter state tree)

var renderString $ \ (state tree)
  state.update :code $ \ (code)
    + code $ JSON.stringify tree

var writeProgram $ \ (state tree)
  writeLines state $ tree.get :body

var writeLines $ \ (state lines)
  lines.reduce
    \ (acc line)
      var lineResult $ write acc line
      lineResult.update :code $ \ (code)
        + code semicolon newline
    , state

var writeInclude $ \ (state tree)
  state.update :code $ \ (code)
    + code :#include blank :< (tree.get :data) :>

var writeInt $ \ (state tree)
  state.update :code $ \ (code)
    + code :int blank (tree.get :data)

var writeFloat $ \ (state tree)
  state.update :code $ \ (code)
    + code :float blank (tree.get :data)

var writeChar $ \ (state tree)
  state.update :code $ \ (code)
    + code :char blank (tree.get :data) :[ (tree.get :length) :]

var writeString $ \ (state tree)
  state.update :code $ \ (code)
    + code :char blank (tree.get :data)
