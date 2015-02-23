{- |  And now we interpret it as HTML.
-}
module Examples.Graphics.UI.Grouped.HTML where

  import Examples.Graphics.UI.Grouped (grouped)

  import Graphics.UI (backgroundRGB)
  import Graphics.UI.Color.RGB (RGB(..))
  import Graphics.UI.Interpreter.HTML (body', html', printHTML)

  main = printHTML $ html' $ (body' [grouped]
    # backgroundRGB (RGB {red: 230, green: 213, blue: 193}))
