
var
  clir $ require :../src/clir
  sourceCode $ require :./examples/include.cr

console.log $ clir.transform sourceCode
