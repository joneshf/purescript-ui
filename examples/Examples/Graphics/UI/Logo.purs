{- | We want to have the PureScript logo follow the mouse.
-}
module Examples.Graphics.UI.Logo (Logo, logo) where

  import Data.Tuple (Tuple(..), uncurry)

  import FRP.Kefir (EffKefir(), Unregister(), fromEvent, onValue)

  import Graphics.UI
    ( Image, image
    , Position, position
    )

  -- | We make a constraint synonym.
  -- | If an interpreter implements `Image` and `Position`,
  -- | it can make the `Logo` UI.
  class (Image g, Position g) <= Logo g

  url :: String
  url = "https://raw.githubusercontent.com/goodworkson/purescript-logo/master/ps_avatar.png"

  rawLogo :: forall g. (Logo g) => g
  rawLogo = image url

  -- | Put the logo at a specific position.
  moveLogo :: forall g. (Logo g) => Number -> Number -> g
  moveLogo x y = rawLogo
               # position x y

  -- | Set up a `mousemove` listener with kefir.
  -- | Each time it fires, move the logo.
  logo :: forall eff g. (Logo g) => (g -> EffKefir eff _) -> EffKefir eff (Unregister eff)
  logo renderer = do
    s <- fromEvent window "mousemove" (\ev -> Tuple ev.clientX ev.clientY)
    onValue s (uncurry moveLogo >>> renderer)

  foreign import window :: forall a. a
