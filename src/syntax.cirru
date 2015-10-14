
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
        else $ transformComment state tree
    parseToken state tree

var parseToken $ \ (state token)
  state.set :result token

= exports.transform transform

var transformInclude $ \ (state tree)
  state.set :result
    ast.include.set :data $ tree.get 0

var transformAssign $ \ (state tree)

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

var transformGreater $ \ (state tree)

var transformLittler $ \ (state tree)

var transformGreaterEqual $ \ (state tree)

var transformLittlerEqual $ \ (state tree)

var transformComment $ \ (state tree)
  ast.comment.set :data tree

var transformAdd $ \ (state tree)

var transformMinus $ \ (state tree)

var transformMultiply $ \ (state tree)

var transformDivision $ \ (state tree)

var transformMod $ \ (state tree)

var transformAnd $ \ (state tree)

var transformOr $ \ (state tree)

var transformNot $ \ (state tree)
