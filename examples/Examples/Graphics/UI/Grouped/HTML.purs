{- |  And now we interpret it as HTML.
-}
module Examples.Graphics.UI.Grouped.HTML where

  import Examples.Graphics.UI.Grouped (grouped)

  import Graphics.UI.Interpreter.HTML (body', html', printHTML)

  main = printHTML $ html' $ body' [grouped]
