module Graphics.UI.Color.Hex (Hex()) where

  import qualified Graphics.UI.Color.Hex.Internal as I

  type Hex = I.Hex

module Graphics.UI.Color.Hex.Internal where

  import Data.Profunctor (Profunctor, dimap)

  import Graphics.UI.Color.RGB (RGB(), _RGB, red, green, blue)

  import Optic.Core

  newtype Hex = Hex RGB

  runHex :: Hex -> RGB
  runHex (Hex rgb) = rgb

  instance showHex :: Show Hex where
    show (Hex rgb) = "#"
                  ++ rgb^._RGB..red..to toHex
                  ++ rgb^._RGB..green..to toHex
                  ++ rgb^._RGB..blue..to toHex

  type IsoP s a = forall f p. (Functor f, Profunctor p) => p a (f a) -> p s (f s)

  _Hex :: IsoP Hex RGB
  _Hex = dimap runHex (Hex <$>)

  foreign import toHex """
    function toHex(num) {
      var hex = num.toString("16");
      return hex.length == 1 ? "0" + hex : hex;
    }""" :: Number -> String
