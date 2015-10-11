
var
  fs $ require :fs
  webpack $ require :webpack

= module.exports $ {}
  :entry $ {}
    :vendor $ [] :immutable :cirru-parser
      , :webpack-dev-server/client?http://repo:8080
      , :webpack/hot/dev-server
    :main $ [] :./test/dev.cirru

  :output $ {}
    :path :build/
    :filename :[name].js
    :publicPath :http://repo:8080/build/

  :resolve $ {}
    :extensions $ [] :.js :.cirru :

  :module $ {}
    :loaders $ []
      {} (:test /\.cirru$) (:loader :cirru-script) (:ignore /examples)
      {} (:test /\.cr$) (:loader :raw)

  :plugins $ []
    new webpack.optimize.CommonsChunkPlugin :vendor :vendor.js
