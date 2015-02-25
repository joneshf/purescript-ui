module Graphics.UI.Interpreter.ReactSimple where

  import Control.Monad.Eff
  import Control.Monad.Eff.Unsafe

  import Data.Array
  import Data.Function

  import DOM

  import Graphics.UI
    ( Button, button
    , GroupHorizontal, groupHorizontal
    , GroupVertical, groupVertical
    , Height, height
    , Image, image
    , Margin, margin
    , Padding, padding
    , Position, position
    , Text, text
    , Width, width
    )

  import qualified React       as R
  import qualified React.Types as R
  import qualified React.DOM   as R

  instance buttonComponent :: Button R.Component (Eff eff Unit) where
    button label ev = R.createClass R.spec
      { render = \this -> pure $ R.button
        { onClick: R.eventHandler this (\t e -> unsafeInterleaveEff ev)
        , style: this.props.style
        }
        [R.rawText label]
      } {style: {}} []

  instance groupHorizontalComponent :: GroupHorizontal R.Component where
    groupHorizontal = R.span {}

  instance groupVerticalComponent :: GroupVertical R.Component where
    groupVertical comps = R.div {} (comps <#> \comp -> R.div {} [comp])

  instance heightComponent :: Height R.Component where
    height h comp = runFn2 R.cloneWithProps comp
      {style: { display: "inline-block"
              , height: show h ++ "px"
              }
      }

  instance imageComponent :: Image R.Component where
    image url = R.img {src: url} []

  instance marginComponent :: Margin R.Component where
    margin m comp = runFn2 R.cloneWithProps comp
      {style: { display: "inline-block"
              , margin: show m ++ "px"
              }
      }

  instance paddingComponent :: Padding R.Component where
    padding p comp = runFn2 R.cloneWithProps comp
      {style: { display: "inline-block"
              , padding: show p ++ "px"
              }
      }

  instance positionComponent :: Position R.Component where
    position x y comp = runFn2 R.cloneWithProps comp
      {style: { display: "inline-block"
              , position: "absolute"
              , left: show x ++ "px"
              , top: show y ++ "px"
              }
      }

  instance textComponent :: Text R.Component where
    text str = R.createClass R.spec
      { render = \this -> pure $ R.span
        {style: this.props.style}
        [R.rawText this.props.text]
      } {style: {}, text: str} []

  instance widthComponent :: Width R.Component where
    width w comp = runFn2 R.cloneWithProps comp
      {style: { display: "inline-block"
              , width: show w ++ "px"
              }
      }
