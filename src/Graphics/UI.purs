{- | Here we specify the possible ways to build UI's. -}
module Graphics.UI where

  -- | We can make some text.
  class Text lang where
    text :: String -> lang

  -- | We can color the representation.
  class ColorStyle lang where
    color :: Color -> lang -> lang

  -- | The possible colors we can make.
  data Color = Black
             | White
             | Red
