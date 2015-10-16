
var
  parser $ require :cirru-parser
  Immutable $ require :immutable

var
  syntax $ require :./syntax
  stringify $ require :./stringify
  ast $ require :./ast

var initialState $ Immutable.fromJS $ {}
  :types $ {}
  :structs $ {}
  :result $ []

= exports.transform $ \ (source)
  var
    syntaxTree $ Immutable.fromJS $ parser.pare source :runtime
    nextState $ syntaxTree.reduce
      \ (acc statement)
        acc.update :result $ \ (result)
          var lineState $ syntax.transform acc statement
          result.push $ lineState.get :result
      , initialState
    astTree $ ast.program.set :body $ nextState.get :result
    code $ stringify.write astTree

  console.log code
