{- |  And now we interpret it as `Wish`.
-}
module Examples.Graphics.UI.Grouped.Wish where

  import Examples.Graphics.UI.Grouped (Grouped, grouped)

  import Graphics.UI.Interpreter.Wish (Wish(), printWish)

  main = printWish grouped

  instance groupedWish :: Grouped Wish
