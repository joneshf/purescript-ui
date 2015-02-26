{- |  And now we interpret it as HTML.
-}
module Examples.Graphics.UI.Grouped.HTML where

  import Control.Monad.Eff (Eff())

  import Debug.Trace (Trace(), trace)

  import Examples.Graphics.UI.Grouped (Grouped, grouped)

  import Graphics.UI (backgroundRGB)
  import Graphics.UI.Color.RGB (RGB(..))
  import Graphics.UI.Interpreter.HTML (BodyTag(), body', html', printHTML)

  main = printHTML $ html' (body' [grouped]
    # backgroundRGB (RGB {red: 230, green: 213, blue: 193}))

  instance groupedHTML :: Grouped BodyTag
