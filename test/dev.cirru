
var
  clir $ require :../src/clir
  sourceCode $ require :./examples/mix.cr

console.log $ clir.transform sourceCode
