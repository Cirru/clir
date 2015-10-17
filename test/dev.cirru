
var
  clir $ require :../src/clir
  sourceCode $ require :./examples/expression.cr

console.log $ clir.transform sourceCode
