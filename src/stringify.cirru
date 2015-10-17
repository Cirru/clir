
var
  Immutable $ require :immutable

var
  blank ": "
  newline ":\n"
  semicolon :;
  quote ":\""
  lParen ":("
  rParen ":)"

= exports.write $ \ (ast)
  var initialState $ Immutable.fromJS $ {}
    :code newline
    :indentation :
  ... (write initialState ast) (get :code)

var bind $ \ (v k) (k v)

var write $ \ (state tree inline)
  bind
    case (tree.get :type)
      :program writeProgram
      :#include writeInclude
      :int writeInt
      :float writeFloat
      :char writeChar
      :string writeString
      :assign writeAssign
      :token wirteToken
      :if writeIf
      :greater writeGreater
      :application writeApplication
      :struct writeStruct
      :function writeFunction
      :type writeType
      :return writeReturn
      :add writeAdd
      :switch writeSwitch
      :case writeCase
      :and writeAnd
      else renderString
    \ (codeWriter)
      cond inline
        cond (is (tree.get :type) :token)
          codeWriter state tree
          bind state $ \ (state)
            var state1 $ state.update :code $ \ (code)
              + code lParen
            var state2 $ codeWriter state1 tree
            state2.update :code $ \ (code)
              + code rParen
        codeWriter state tree

var renderString $ \ (state tree)
  state.update :code $ \ (code)
    + code $ JSON.stringify tree

var writeProgram $ \ (state tree)
  writeLines state $ tree.get :body

var writeLines $ \ (state lines)
  lines.reduce
    \ (acc line)
      var state1 $ acc.update :code $ \ (code)
        + code (acc.get :indentation)
      var lineResult $ write state1 line
      lineResult.update :code $ \ (code)
        + code semicolon newline
    , state

var writeItems $ \ (state items)
  items.reduce
    \ (acc item index)
      var itemResult $ write acc item
      itemResult.update :code $ \ (code)
        cond (< (+ index 1) items.size)
          + code :, blank
          , code
    , state

var writeApplication $ \ (state tree)
  var state1 $ state.update :code $ \ (code)
    + code (tree.get :function) lParen
  var state2 $ writeItems state1 (tree.get :arguments)
  state2.update :code $ \ (code)
    + code rParen

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

var writeAssign $ \ (state tree)
  var state1 $ write state (tree.get :left)
  var state2 $ state1.update :code $ \ (code)
    + code blank := blank
  write state2 (tree.get :right)

var wirteToken $ \ (state tree)
  var token $ tree.get :data
  state.update :code $ \ (code)
    + code $ case true
      (? $ token.match /^:)
        + quote (token.slice 1) quote
      (? $ token.match /^\d) token
      (? $ token.match /^\w) token
      else $ + :__ token :__

var writeIf $ \ (state tree)
  var state1 $ state.update :code $ \ (code)
    + code :if blank lParen
  var state2 $ write state1 $ tree.get :condition
  var state3 $ ... state2
    update :code $ \ (code)
      + code rParen blank :{ newline
    update :indentation $ \ (indentation)
      + indentation blank blank
  var state4 $ writeLines state3 $ tree.get :consequence
  var state5 $ state4.update :indentation $ \ (indentation)
    indentation.slice 2
  var state6 $ ... state5
    update :code $ \ (code)
      + code :} blank :else blank :{ newline
    update :indentation $ \ (indentation)
      + indentation blank blank
  var state7 $ writeLines state6 $ tree.get :alternative
  var state8 $ state7.update :indentation $ \ (indentation)
    indentation.slice 2
  state8.update :code $ \ (code)
    + code :}

var writeGreater $ \ (state tree)
  var state1 $ write state (tree.get :left) true
  var state2 $ state1.update :code $ \ (code)
    + code blank :> blank
  write state2 (tree.get :right) true

var writeAnd $ \ (state tree)
  var state1 $ write state (tree.get :left) true
  var state2 $ state1.update :code $ \ (code)
    + code blank :&& blank
  write state2 (tree.get :right) true

var writeStruct $ \ (state tree)
  var structName $ tree.get :name
  var state1 $ ... state
    update :code $ \ (code)
      + code :struct blank structName blank :{ newline
    update :indentation $ \ (indentation)
      + indentation blank blank
  var state2 $ writeLines state1 $ tree.get :body
  var state3 $ state2.update :indentation $ \ (indentation)
    indentation.slice 2
  state3.update :code $ \ (code)
    + code :}

var writeFunction $ \ (state tree)
  var state1 $ state.update :code $ \ (code)
    + code (tree.get :returnType) blank (tree.get :name) lParen
  var state2 $ writeItems state1 $ tree.get :arguments
  var state3 $ ... state2
    update :code $ \ (code)
      + code rParen blank :{ newline
    update :indentation $ \ (indentation)
      + indentation blank blank
  var state4 $ writeLines state3 $ tree.get :body
  var state5 $ state4.update :indentation $ \ (indentation)
    indentation.slice 2
  state5.update :code $ \ (code)
    + code :}

var writeType $ \ (state tree)
  state.update :code $ \ (code)
    + code (tree.get :name) blank (tree.get :data)

var writeReturn $ \ (state tree)
  var state1 $ state.update :code $ \ (code)
    + code :return blank
  write state1 $ tree.get :data

var writeAdd $ \ (state tree)
  var state1 $ write state $ tree.get :left
  var state2 $ state1.update :code $ \ (code)
    + code blank :+ blank
  write state2 $ tree.get :right

var writeSwitch $ \ (state tree)
  var state1 $ state.update :code $ \ (code)
    + code :switch blank lParen
  var state2 $ write state1 $ tree.get :value
  var state3 $ ... state2
    update :code $ \ (code)
      + code rParen blank :{ newline
    update :indentation $ \ (indentation)
      + indentation blank blank
  var state4 $ ... (tree.get :body) $ reduce
    \ (acc line)
      var lineCase $ line.get 0
      var lineBody $ line.get 1
      var acc1 $ acc.update :code $ \ (code)
        + code $ acc.get :indentation
      var acc2 $ write acc1 lineCase
      var acc3 $ ... acc2
        update :code $ \ (code)
          + code :: newline
        update :indentation $ \ (indentation)
          + indentation blank blank
      var acc4 $ writeLines acc3 lineBody
      acc4.update :indentation $ \ (indentation)
        indentation.slice 2
    , state3
  var state5 $ state4.update :indentation $ \ (indentation)
    indentation.slice 2
  state5.update :code $ \ (code)
    + code :}

var writeCase $ \ (state tree)
  var state1 $ state.update :code $ \ (code)
    + code :case blank
  write state1 $ tree.get :data
