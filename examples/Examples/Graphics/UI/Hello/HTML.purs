{- |  We interpret the `hello` UI as a full HTML file
-}
module Examples.Graphics.UI.Hello.HTML where

  import Examples.Graphics.UI.Hello (hello)

  import Graphics.UI.Interpreter.HTML (printHTML)

  main = printHTML hello
