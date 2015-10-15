
var
  clir $ require :../src/clir
  sourceCode $ require :./examples/struct.cr

console.log $ clir.transform sourceCode
