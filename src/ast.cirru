
var
  Immutable $ require :immutable

= exports.program $ Immutable.fromJS $ {}
  :type :program
  :data $ []

= exports.include $ Immutable.fromJS $ {}
  :type :#include
  :data null

= exports.assign $ Immutable.fromJS $ {}
  :type :assign
  :data $ {}
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

= exports.string $ Immutable.fromJS $ {}
  :type :string
  :data null

= exports.application $ Immutable.fromJS $ {}
  :type :application
  :data $ {}
    :function null
    :arguments $ []

= exports.function $ Immutable.fromJS $ {}
  :type :function
  :data $ {}
    :type $ {}
      :arguments $ []
      :return null
    :arguments $ []
    :body $ []

= exports.struct $ Immutable.fromJS $ {}
  :type :struct
  :data $ {}
    :name null
    :body $ []

= exports.if $ Immutable.fromJS $ {}
  :type :if
  :data $ {}
    :condition null
    :consequence $ []
    :alternative $ []

= exports.comment $ Immutable.fromJS $ {}
  :type :comment
  :data null

= exports.add $ Immutable.fromJS $ {}
  :type :add
  :data $ {}
    :left null
    :right null

= exports.minus $ Immutable.fromJS $ {}
  :type :add
  :data $ {}
    :left null
    :right null

= exports.multiply $ Immutable.fromJS $ {}
  :type :multiply
  :data $ {}
    :left null
    :right null

= exports.division $ Immutable.fromJS $ {}
  :type :division
  :data $ {}
    :left null
    :right null

= exports.mod $ Immutable.fromJS $ {}
  :type :mod
  :data $ {}
    :left null
    :right null

= exports.greater $ Immutable.fromJS $ {}
  :type :greater
  :data $ {}
    :left null
    :right null

= exports.littler $ Immutable.fromJS $ {}
  :type :littler
  :data $ {}
    :left null
    :right null

= exports.greaterEqual $ Immutable.fromJS $ {}
  :type :greaterEqual
  :data $ {}
    :left null
    :right null

= exports.littlerEqual $ Immutable.fromJS $ {}
  :type :littlerEqual
  :data $ {}
    :left null
    :right null

= exports.and $ Immutable.fromJS $ {}
  :type :and
  :data $ {}
    :left null
    :right null

= exports.or $ Immutable.fromJS $ {}
  :type :or
  :data $ {}
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
  :data $ {}
    :value null
    :body $ []
