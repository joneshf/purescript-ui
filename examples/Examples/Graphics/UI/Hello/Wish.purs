{- |  We interpret the `hello` UI as a `Wish` file.
-}
module Examples.Graphics.UI.Hello.Wish where

  import Graphics.UI.Interpreter.Wish (printWish)

  import Examples.Graphics.UI.Hello (hello)

  main = printWish hello
