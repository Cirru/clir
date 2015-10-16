
var
  parser $ require :cirru-parser
  Immutable $ require :immutable

var
  syntax $ require :./syntax
  stringify $ require :./stringify
  ast $ require :./ast

var initialState $ Immutable.fromJS $ {}
  :declarations $ {}
  :result $ []

= exports.transform $ \ (source)
  var
    syntaxTree $ Immutable.fromJS $ parser.pare source :runtime
    nextState $ syntaxTree.reduce
      \ (acc statement)
        var lineState $ syntax.transform acc statement
        var lastResult $ acc.get :result
        lineState.update :result $ \ (result)
          cond (? $ lineState.get :result)
            lastResult.push $ lineState.get :result
            , lastResult
      , initialState
    astTree $ ast.program.set :body $ nextState.get :result
    code $ stringify.write astTree

  console.log code
