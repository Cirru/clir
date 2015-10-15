
var
  clir $ require :../src/clir
  sourceCode $ require :./examples/switch.cr

console.log $ clir.transform sourceCode
