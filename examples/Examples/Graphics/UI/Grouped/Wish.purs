{- |  And now we interpret it as `Wish`.
-}
module Examples.Graphics.UI.Grouped.Wish where

  import Examples.Graphics.UI.Grouped (grouped)

  import Graphics.UI.Interpreter.Wish (printWish)

  main = printWish grouped
