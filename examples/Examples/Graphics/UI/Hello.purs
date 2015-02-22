module Examples.Graphics.UI.Hello where

  import Graphics.UI (Text, text)

  hello :: forall g. (Text g) => g
  hello = text "Hello World"
