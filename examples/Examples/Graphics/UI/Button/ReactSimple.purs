{- |  We interpret the `button` UI as a `ReactSimple` component.
-}
module Examples.Graphics.UI.Button.ReactSimple where

  import Graphics.UI.Interpreter.ReactSimple ()

  import Examples.Graphics.UI.Button (Display, display)

  import React (renderComponentById)
  import React.Types (Component())

  main = display (\comp -> renderComponentById comp "content" # void)

  instance displayComponent :: Display Component
