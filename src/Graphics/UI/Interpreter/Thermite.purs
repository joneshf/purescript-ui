module Graphics.UI.Interpreter.Thermite where

  import Control.Monad.Eff
  import Control.Monad.Eff.Unsafe

  import Graphics.UI
    ( Button, button
    , GroupHorizontal, groupHorizontal
    , Text, text
    )

  import qualified Thermite               as T
  import qualified Thermite.Action        as T
  import qualified Thermite.Html          as T
  import qualified Thermite.Html.Elements as T
  import qualified Thermite.Events        as T
  import qualified Thermite.Types         as T

  instance buttonThermiteComponentClass :: Button (T.ComponentClass props eff) (T.MouseEvent -> action) where
    button label ev =
      T.createClass $ T.simpleSpec unit (\_ _ -> pure unit) (\ctx _ _ -> button' ctx)
      where
        button' ctx = T.button [T.onClick ctx ev] [T.text label]

  instance buttonThermiteComponentClassEff :: Button (T.ComponentClass props eff) (Eff eff a) where
    button label ev =
      T.createClass $ T.simpleSpec unit (\_ _ -> pure unit) (\ctx _ _ -> button' ctx)
      where
        button' ctx = T.button [T.onClick ctx \_ -> runPure (unsafeInterleaveEff ev)] [T.text label]

  instance groupHorizontalHtml :: GroupHorizontal (T.Html action) where
    groupHorizontal = T.span'

  -- Not yet...
  -- instance groupHorizontalComponentClass :: GroupHorizontal (T.ComponentClass props eff) where
  --   groupHorizontal cs =
  --     T.createClass $ T.simpleSpec unit
  --                                  (\_ _ -> pure unit)
  --                                  (\_ _ _ -> T.span' cs)

  instance textThermiteHtml :: Text (T.Html action) where
    text str = T.p' [T.text str]

  instance textThermiteComponentClass :: Text (T.ComponentClass props eff) where
    text s =
      T.createClass $ T.simpleSpec unit (\_ _ -> pure unit) (\_ _ _ -> text s)
