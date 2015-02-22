{- |  We create one abstract representation of a UI here.
      Later on we interpret it in different contexts.
-}
module Examples.Graphics.UI.Hello where

  import Graphics.UI (Text, text)

  hello :: forall g. (Text g) => g
  hello = text "Hello World"
