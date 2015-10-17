
var
  clir $ require :../src/clir
  sourceCode $ require :./examples/assignment.cr

console.log $ clir.transform sourceCode
