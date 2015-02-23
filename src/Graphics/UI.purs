{- | Here we specify the possible ways to build UI's. -}
module Graphics.UI where

  import Graphics.UI.Color.Name (Name())
  import Graphics.UI.Color.RGB (RGB())

  -- | We can color the representation.
  class BackgroundColorName lang where
    backgroundColor :: Name -> lang -> lang

  -- | We can color the representation.
  class ColorName lang where
    color :: Name -> lang -> lang

  -- | We can color the representation.
  class BackgroundColorRGB lang where
    backgroundRGB :: RGB -> lang -> lang

  -- | We can color the representation.
  class ColorRGB lang where
    rgb :: RGB -> lang -> lang

  -- | We can vertically align multiple UI's
  class GroupVertical lang where
    groupVertical :: [lang] -> lang

  -- | We can horizontally align multiple UI's
  class GroupHorizontal lang where
    groupHorizontal :: [lang] -> lang

  -- | A simple list of things.
  class List lang where
    list :: [lang] -> lang

  -- | We can make some text.
  class Text lang where
    text :: String -> lang

  -- | We can set the title of a UI.
  class Title lang where
    title :: String -> lang -> lang
