module Examples.Graphics.UI.Hello where

  import Graphics.UI

  hello :: forall g. (Text g) => g
  hello = text "Hello World"
