{- |  Now, we create something a bit more vibrant.
-}
module Examples.Graphics.UI.Colorful where

  import Graphics.UI (ColorName, color, Text, text)
  import Graphics.UI.Color.Name (Name(Green))

  -- | The constraints here (`ColorName` and `Text`)
  -- | ensure at compile time that we can't accidentally try to color something
  -- | that can't be colored.
  colorful :: forall g. (ColorName g, Text g) => g
  colorful = color Green $ text "Look at this green text!"
