{- |  We interpret the colorful text as an `HTML` File.
-}
module Examples.Graphics.UI.Colorful.HTML where

  import Examples.Graphics.UI.Colorful (colorful)

  import Graphics.UI.Interpreter.HTML (printHTML)

  main = printHTML colorful
