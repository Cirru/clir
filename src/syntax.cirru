
var
  Immutable $ require :immutable

var
  ast $ require :./ast

var bind $ \ (v k) (k v)

var transform $ \ (state tree)
  cond (Immutable.List.isList tree)
    bind (tree.get 1) $ \ (op)
      case op
        :#include $ transformInclude state tree
        := $ transformAssign state tree
        :int $ transformInt state tree
        :float $ transformFloat state tree
        :char $ transformChar state tree
        :string $ transformString state tree
        ::: $ transformFunctionType state tree
        :\ $ transformFunction state tree
        :if $ transformIf state tree
        :== $ transformEqual state tree
        :> $ transformGreater state tree
        :< $ transformLittler state tree
        :>= $ transformGreaterEqual state tree
        :<= $ transformLittlerEqual state tree
        :-- $ transformComment state tree
        :+ $ transformAdd state tree
        :- $ transformMinus state tree
        :* $ transformMultiply state tree
        :/ $ transformDivision state tree
        :% $ transformMod state tree
        :and $ transformAnd state tree
        :or $ transformOr state tree
        :not $ transformNot state tree
        :! $ transformApplication state tree
        :struct $ transformStruct state tree
        :switch $ transformSwitch state tree
        :case $ transformCase state tree
        else $ transformComment state tree
    parseToken state tree

var parseToken $ \ (state token)
  state.set :result $ {}
    :type :token
    :data token

var extract $ \ (x)
  x.get :result

= exports.transform transform

var transformInclude $ \ (state tree)
  state.set :result
    ast.include.set :data $ tree.get 0

var transformAssign $ \ (state tree)
  state.set :result
    ... ast.assign
      setIn ([] :data :left) $ extract $ transform state $ tree.get 0
      setIn ([] :data :right) $ extract $ transform state $ tree.get 2

var transformInt $ \ (state tree)
  state.set :result
    ast.int.set :data $ tree.get 0

var transformFloat $ \ (state tree)
  state.set :result
    ast.float.set :data $ tree.get 0

var transformChar $ \ (state tree)
  state.set :result
    ast.char.set :data $ tree.get 0

var transformString $ \ (state tree)
  state.set :result
    ast.string.set :data $ tree.get 0

var transformFunctionType $ \ (state tree)

var transformFunction $ \ (state tree)

var transformIf $ \ (state tree)
  var
    firstBranch $ tree.get 2
    secondBranch $ tree.get 3
    firstLabel $ tree.getIn $ [] 2 0
  if (not firstLabel) $ do
    var temp firstBranch
    = firstBranch secondBranch
    = secondBranch temp
  state.set :result
    ... ast.if
      setIn ([] :data :condition) $ extract $ transform state (tree.get 0)
      setIn ([] :data :consequence) $ cond (? firstBranch)
        extract $ transformItems state (firstBranch.slice 1)
        , null
      setIn ([] :data :alternative) $ cond (? secondBranch)
        extract $ transformItems state (secondBranch.slice 1)
        , null

var transformItems $ \ (state lines)
  lines.reduce
    \ (acc lineStatement)
      acc.update :result $ \ (result)
        var lineState $ transform acc lineStatement
        result.push $ lineState.get :result
    , state

var transformGreater $ \ (state tree)
  state.set :result
    ... ast.greater
      setIn ([] :data :left) $ extract $ transform state (tree.get 0)
      setIn ([] :data :right) $ extract $ transform state (tree.get 2)

var transformLittler $ \ (state tree)
  state.set :result
    ... ast.littler
      setIn ([] :data :left) $ extract $ transform state (tree.get 0)
      setIn ([] :data :right) $ extract $ transform state (tree.get 2)

var transformGreaterEqual $ \ (state tree)
  state.set :result
    ... ast.greaterEqual
      setIn ([] :data :left) $ extract $ transform state (tree.get 0)
      setIn ([] :data :right) $ extract $ transform state (tree.get 2)

var transformLittlerEqual $ \ (state tree)
  state.set :result
    ... ast.littlerEqual
      setIn ([] :data :left) $ extract $ transform state (tree.get 0)
      setIn ([] :data :right) $ extract $ transform state (tree.get 2)

var transformComment $ \ (state tree)
  state.set :result
    ast.comment.set :data tree

var transformAdd $ \ (state tree)
  state.set :result
    ... ast.add
      setIn ([] :data :left) $ extract $ transform state (tree.get 0)
      setIn ([] :data :right) $ extract $ transform state (tree.get 2)

var transformMinus $ \ (state tree)
  state.set :result
    ... ast.minus
      setIn ([] :data :left) $ extract $ transform state (tree.get 0)
      setIn ([] :data :right) $ extract $ transform state (tree.get 2)

var transformMultiply $ \ (state tree)
  state.set :result
    ... ast.multply
      setIn ([] :data :left) $ extract $ transform state (tree.get 0)
      setIn ([] :data :right) $ extract $ transform state (tree.get 2)

var transformDivision $ \ (state tree)
  state.set :result
    ... ast.division
      setIn ([] :data :left) $ extract $ transform state (tree.get 0)
      setIn ([] :data :right) $ extract $ transform state (tree.get 2)

var transformMod $ \ (state tree)
  state.set :result
    ... ast.mod
      setIn ([] :data :left) $ extract $ transform state (tree.get 0)
      setIn ([] :data :right) $ extract $ transform state (tree.get 2)

var transformAnd $ \ (state tree)
  state.set :result
    ... ast.and
      setIn ([] :data :left) $ extract $ transform state (tree.get 0)
      setIn ([] :data :right) $ extract $ transform state (tree.get 2)

var transformOr $ \ (state tree)
  state.set :result
    ... ast.or
      setIn ([] :data :left) $ extract $ transform state (tree.get 0)
      setIn ([] :data :right) $ extract $ transform state (tree.get 2)

var transformNot $ \ (state tree)
  state.set :result
    ... ast.not
      set :data $ transform state (tree.get 0)

var transformApplication $ \ (state tree)
  var functionName $ tree.get 0
  var items $ tree.slice 2
  state.set :result
    ... ast.application
      setIn ([] :data :function) functionName
      setIn ([] :data :arguments) $ extract $ transformItems state items

var transformStruct $ \ (state tree)
  var structName $ tree.get 0
  var structBody $ tree.slice 2
  state.set :result
    ... ast.struct
      setIn ([] :data :name) structName
      setIn ([] :data :body) $ extract $ transformItems state structBody

var transformSwitch $ \ (state tree)
  var condition $ tree.get 0
  var switchBody $ tree.slice 2
  state.set :result
    ... ast.switch
      setIn ([] :data :value) $ extract $ transform state condition
      setIn ([] :data :body)
        switchBody.map $ \ (casePair)
          Immutable.fromJS $ []
            casePair.get 0
            transformItems state (casePair.slice 1)

var transformCase $ \ (state tree)
