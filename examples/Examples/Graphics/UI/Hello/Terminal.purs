{- |  We interpret the `hello` UI as `Terminal` output.
-}
module Examples.Graphics.UI.Hello.Terminal where

  import Examples.Graphics.UI.Hello (hello)

  import Graphics.UI.Terminal (printTerminal)

  main = printTerminal hello
