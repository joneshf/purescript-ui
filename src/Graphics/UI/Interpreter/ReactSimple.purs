module Graphics.UI.Interpreter.ReactSimple where

  import Control.Monad.Eff
  import Control.Monad.Eff.Unsafe

  import Data.Array

  import DOM

  import Graphics.UI
    ( Button, button
    , GroupHorizontal, groupHorizontal
    , GroupVertical, groupVertical
    , Text, text
    )

  import qualified React       as R
  import qualified React.Types as R
  import qualified React.DOM   as R

  instance buttonComponent :: Button R.Component (Eff eff Unit) where
    button label ev = R.createClass R.spec
      { render = \this -> pure $ R.button
        {onClick: R.eventHandler this (\t e -> unsafeInterleaveEff ev)}
        [R.rawText label]
      } {} []

  instance groupHorizontalComponent :: GroupHorizontal R.Component where
    groupHorizontal = R.span {}

  instance groupVerticalComponent :: GroupVertical R.Component where
    groupVertical comps = R.div {} (comps <#> \comp -> R.div {} [comp])

  instance textComponent :: Text R.Component where
    text str = R.span {} [R.rawText str]
