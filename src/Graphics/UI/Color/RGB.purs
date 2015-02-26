module Graphics.UI.Color.RGB where

  newtype RGB = RGB RGBRec
  type RGBRec = {red :: Number, green :: Number, blue :: Number}

  instance showRGB :: Show RGB where
    show (RGB rec) = "RGB "
                  ++ "{red: "    ++ show rec.red
                  ++ ", green: " ++ show rec.green
                  ++ ", blue: "  ++ show rec.blue
                  ++ "}"

  type LensP s a = forall f. (Functor f) => (a -> f a) -> s -> f s

  _RGB :: LensP RGB RGBRec
  _RGB f (RGB rec) = f rec <#> RGB

  red :: LensP {red :: Number | _} Number
  red f rgb = f rgb.red <#> rgb{red = _}

  green :: LensP {green :: Number | _} Number
  green f rgb = f rgb.green <#> rgb{green = _}

  blue :: LensP {blue :: Number | _} Number
  blue f rgb = f rgb.blue <#> rgb{blue = _}
