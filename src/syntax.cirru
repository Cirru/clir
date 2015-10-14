
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
        :then $ transformThen state tree
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
        :do $ transformDo state tree
        else $ transformComment state tree
    parseToken state tree

var parseToken $ \ (state token)
  state.set :result token

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

var transformThen $ \ (state tree)
  state.set :result
    ... ast.then
      setIn ([] :data :condition) $ extract $ transform state (tree.get 0)
      setIn ([] :data :concequence) $ extract $ transform state (tree.get 2)
      setIn ([] :data :alternative) $ extract $ transform state (tree.get 3)

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

var
  transformDo $ \ (state tree)
    tree.reduce
      \ (acc line)
        acc.update :result $ \ (result)
          result.push $ extract $ transform acc line
      , state
