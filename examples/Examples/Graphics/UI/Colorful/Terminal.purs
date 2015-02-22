{- |  We interpret the colorful text as a `Terminal` output.
-}
module Examples.Graphics.UI.Colorful.Terminal where

  import Examples.Graphics.UI.Colorful (colorful)

  import Graphics.UI.Interpreter.Terminal (printTerminal)

  main = printTerminal colorful
