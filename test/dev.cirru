
var
  clir $ require :../src/clir
  sourceCode $ require :./examples/type.cr

console.log $ clir.transform sourceCode
