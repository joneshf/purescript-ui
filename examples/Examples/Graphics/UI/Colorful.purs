{- |  Now, we create something a bit more vibrant.
-}
module Examples.Graphics.UI.Colorful where

  import Graphics.UI (ColorSimple, color, Text, text)
  import Graphics.UI.Color (Color(Green))

  -- | The constraints here (`ColorSimple` and `Text`)
  -- | ensure at compile time that we can't accidentally try to color something
  -- | that can't be colored.
  colorful :: forall g. (ColorSimple g, Text g) => g
  colorful = color Green $ text "Look at this green text!"
