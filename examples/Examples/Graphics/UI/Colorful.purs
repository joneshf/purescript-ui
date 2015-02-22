{- |  Now, we create something a bit more vibrant.
-}
module Examples.Graphics.UI.Colorful where

  import Graphics.UI (ColorSimple, color, Text, text, Color(Green))

  colorful :: forall g. (ColorSimple g, Text g) => g
  colorful = color Green $ text "Look at this green text!"
