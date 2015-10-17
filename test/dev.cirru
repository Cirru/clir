
var
  clir $ require :../src/clir
  sourceCode $ require :./examples/condition.cr

console.log $ clir.transform sourceCode
