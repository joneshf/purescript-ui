{- | Here we specify the possible ways to build UI's. -}
module Graphics.UI where

  import Graphics.UI.Color (Color())

  -- | We can make some text.
  class Text lang where
    text :: String -> lang

  -- | We can color the representation.
  class ColorSimple lang where
    color :: Color -> lang -> lang

  -- | A simple list of things.
  class List lang where
    list :: [lang] -> lang
