
var
  Immutable $ require :immutable

= exports.program $ Immutable.fromJS $ {}
  :type :program
  :body $ []

= exports.include $ Immutable.fromJS $ {}
  :type :#include
  :data null

= exports.assign $ Immutable.fromJS $ {}
  :type :assign
  :left null
  :right null

= exports.int $ Immutable.fromJS $ {}
  :type :int
  :data null

= exports.float $ Immutable.fromJS $ {}
  :type :float
  :data null

= exports.char $ Immutable.fromJS $ {}
  :type :char
  :data null
  :length 0

= exports.string $ Immutable.fromJS $ {}
  :type :string
  :data null

= exports.application $ Immutable.fromJS $ {}
  :type :application
  :function null
  :arguments $ []

= exports.function $ Immutable.fromJS $ {}
  :type :function
  :declaration $ {}
    :arguments $ []
    :return null
  :arguments $ []
  :body $ []

= exports.struct $ Immutable.fromJS $ {}
  :type :struct
  :name null
  :body $ []

= exports.if $ Immutable.fromJS $ {}
  :type :if
  :condition null
  :consequence $ []
  :alternative $ []

= exports.comment $ Immutable.fromJS $ {}
  :type :comment
  :data null

= exports.add $ Immutable.fromJS $ {}
  :type :add
  :left null
  :right null

= exports.minus $ Immutable.fromJS $ {}
  :type :add
  :left null
  :right null

= exports.multiply $ Immutable.fromJS $ {}
  :type :multiply
  :left null
  :right null

= exports.division $ Immutable.fromJS $ {}
  :type :division
  :left null
  :right null

= exports.mod $ Immutable.fromJS $ {}
  :type :mod
  :left null
  :right null

= exports.greater $ Immutable.fromJS $ {}
  :type :greater
  :left null
  :right null

= exports.littler $ Immutable.fromJS $ {}
  :type :littler
  :left null
  :right null

= exports.greaterEqual $ Immutable.fromJS $ {}
  :type :greaterEqual
  :left null
  :right null

= exports.littlerEqual $ Immutable.fromJS $ {}
  :type :littlerEqual
  :left null
  :right null

= exports.and $ Immutable.fromJS $ {}
  :type :and
  :left null
  :right null

= exports.or $ Immutable.fromJS $ {}
  :type :or
  :left null
  :right null

= exports.not $ Immutable.fromJS $ {}
  :type :not
  :data null

= exports.do $ Immutable.fromJS $ {}
  :type :do
  :data $ []

= exports.switch $ Immutable.fromJS $ {}
  :type :switch
  :value null
  :body $ []

= exports.return $ Immutable.fromJS $ {}
  :type :return
  :data null

= exports.token $ Immutable.fromJS $ {}
  :type :token
  :data null
