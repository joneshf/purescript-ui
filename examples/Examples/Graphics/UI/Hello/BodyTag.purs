{- |  We interpret the `hello` UI as a tag for later use in an `HTML`.
-}
module Examples.Graphics.UI.Hello.BodyTag where

  import Examples.Graphics.UI.Hello (hello)

  import Graphics.UI.Interpreter.HTML

  greeting :: BodyTag
  greeting = hello
