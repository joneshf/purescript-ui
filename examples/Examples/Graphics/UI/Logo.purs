{- | We want to have the PureScript logo follow the mouse.
-}
module Examples.Graphics.UI.Logo (Logo, logo) where

  import Control.Monad.Eff

  import Data.Tuple

  import DOM

  import FRP.Kefir

  import Graphics.UI

  class (Image g, Position g) <= Logo g

  url = "https://raw.githubusercontent.com/goodworkson/purescript-logo/master/ps_avatar.png"

  rawLogo :: forall g. (Logo g) => g
  rawLogo = image url

  moveLogo :: forall g. (Logo g) => Number -> Number -> g
  moveLogo x y = rawLogo
               # position x y

  logo :: forall eff g. (Logo g) => (g -> EffKefir eff _) -> EffKefir eff (Unregister eff)
  logo renderer = do
    s <- fromEvent window "mousemove" (\ev -> Tuple ev.clientX ev.clientY)
    onValue s (uncurry moveLogo >>> renderer)

  foreign import window :: forall a. a
