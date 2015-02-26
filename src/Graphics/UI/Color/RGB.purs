module Graphics.UI.Color.RGB where

  import Data.Profunctor (Profunctor, dimap)

  import Optic.Core

  newtype RGB = RGB RGBRec

  type RGBRec = {red :: Number, green :: Number, blue :: Number}

  runRGB :: RGB -> RGBRec
  runRGB (RGB rec) = rec

  instance showRGB :: Show RGB where
    show (RGB rec) = "RGB "
                  ++ "{red: "    ++ show rec.red
                  ++ ", green: " ++ show rec.green
                  ++ ", blue: "  ++ show rec.blue
                  ++ "}"

  type IsoP s a = forall f p. (Functor f, Profunctor p) => p a (f a) -> p s (f s)

  _RGB :: IsoP RGB RGBRec
  _RGB = dimap runRGB (RGB <$>)

  red :: LensP {red :: Number | _} Number
  red f rgb = f rgb.red <#> rgb{red = _}

  green :: LensP {green :: Number | _} Number
  green f rgb = f rgb.green <#> rgb{green = _}

  blue :: LensP {blue :: Number | _} Number
  blue f rgb = f rgb.blue <#> rgb{blue = _}
