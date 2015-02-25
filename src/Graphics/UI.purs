{- | Here we specify the possible ways to build UI's. -}
module Graphics.UI where

  import Graphics.UI.Color.Name (Name())
  import Graphics.UI.Color.RGB (RGB())

  -- | ## Creation

  -- | We can interact with a UI through an event.
  class Button lang event where
    button :: String -> event -> lang

  -- | We can make an image UI.
  class Image lang where
    image :: String -> lang

  -- | We can make a text UI.
  class Text lang where
    text :: String -> lang

  -- | ## Layout

  -- | We can vertically align multiple UI's
  class GroupVertical lang where
    groupVertical :: [lang] -> lang

  -- | We can horizontally align multiple UI's
  class GroupHorizontal lang where
    groupHorizontal :: [lang] -> lang

  -- | A simple list of UI's.
  class List lang where
    list :: [lang] -> lang

  -- | We can explicitly position a UI.
  class Position lang where
    -- | The position is set by x first then y
    position :: Number -> Number -> lang -> lang

  -- | ## Styling

  -- | #### Color

  -- | We can color background of the UI.
  class BackgroundColorName lang where
    backgroundColor :: Name -> lang -> lang

  -- | We can color background of the UI.
  class BackgroundColorRGB lang where
    backgroundRGB :: RGB -> lang -> lang

  -- | We can color the UI.
  class ColorName lang where
    color :: Name -> lang -> lang

  -- | We can color the UI.
  class ColorRGB lang where
    rgb :: RGB -> lang -> lang

  -- | #### Sizing

  -- | We can set the height of a UI.
  class Height lang where
    height :: Number -> lang -> lang

  -- | We can pad inside a UI.
  class Padding lang where
    padding :: Number -> lang -> lang

  -- | We can create space outside a UI.
  class Margin lang where
    margin :: Number -> lang -> lang

  -- | We can set both the width and the height of a UI.
  class Size lang where
    -- | The size is set by width first and height second.
    size :: Number -> Number -> lang -> lang

  -- | We can set the width of a UI.
  class Width lang where
    width :: Number -> lang -> lang

  -- | ## Miscellaneous

  -- | We can set the title of a UI.
  class Title lang where
    title :: String -> lang -> lang

  -- | Derived instances

  instance sizeFromWHLang :: (Width lang, Height lang) => Size lang where
    size w h l = height h $ width w l

  -- | Helpers

  button' :: forall a e lang. (Show a, Button lang e) => a -> e -> lang
  button' = show >>> button

  text' :: forall a lang. (Show a, Text lang) => a -> lang
  text' = show >>> text

  title' :: forall a lang. (Show a, Title lang) => a -> lang -> lang
  title' = show >>> title
