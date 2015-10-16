
var
  clir $ require :../src/clir
  sourceCode $ require :./examples/function.cr

console.log $ clir.transform sourceCode
