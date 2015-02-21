module Examples.Graphics.UI.Terminal where

  import Debug.Trace

  import Graphics.UI
  import Graphics.UI.Terminal

  main = do
    trace $ runTerminal $ text "Hello World"
    trace $ runTerminal $ color Red $ text "wat?!?"
