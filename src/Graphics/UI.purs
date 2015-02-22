{- | Here we specify the possible ways to build UI's. -}
module Graphics.UI where

  import Graphics.UI.Color.Name (Name())

  -- | We can make some text.
  class Text lang where
    text :: String -> lang

  -- | We can color the representation.
  class ColorName lang where
    color :: Name -> lang -> lang

  -- | A simple list of things.
  class List lang where
    list :: [lang] -> lang
