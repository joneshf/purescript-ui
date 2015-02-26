module Graphics.UI.Color where

  import Graphics.UI.Color.Hex (Hex(..))
  import Graphics.UI.Color.Name (Name(..))
  import Graphics.UI.Color.RGB (RGB(..))

  import qualified Graphics.UI.Color.Hex.Internal as I

  name2RGB :: Name -> RGB
  name2RGB Black  = RGB {red: 0,   green: 0,   blue: 0}
  name2RGB White  = RGB {red: 255, green: 255, blue: 255}
  name2RGB Red    = RGB {red: 255, green: 0,   blue: 0}
  name2RGB Green  = RGB {red: 0,   green: 255, blue: 0}
  name2RGB Yellow = RGB {red: 255, green: 255, blue: 0}
  name2RGB Blue   = RGB {red: 0,   green: 0,   blue: 255}
  name2RGB Purple = RGB {red: 255, green: 0,   blue: 255}

  rgb2Hex :: RGB -> I.Hex
  rgb2Hex = I.Hex

  name2Hex :: Name -> I.Hex
  name2Hex = name2RGB >>> rgb2Hex
