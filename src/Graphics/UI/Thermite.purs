module Graphics.UI.Thermite where

  import Graphics.UI
    (Text, text)

  import qualified Thermite               as T
  import qualified Thermite.Html          as T
  import qualified Thermite.Html.Elements as T
  import qualified Thermite.Types         as T

  instance textThermiteHtml :: Text (T.Html action) where
    text str = T.p' [T.text str]

  instance textThermiteComponentClass :: Text (T.ComponentClass props eff) where
    text s =
      T.createClass $ T.simpleSpec unit (\_ _ -> pure unit) (\_ _ _ -> text s)
