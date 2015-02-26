{- |  We interpret the colorful text as a `Wish` script.
-}
module Examples.Graphics.UI.Colorful.Wish where

  import Examples.Graphics.UI.Colorful (colorful)

  import Graphics.UI.Interpreter.Wish (printWish)

  main = printWish colorful
