{- |  We interpret the `button` UI as a `ReactSimple` component.
-}
module Examples.Graphics.UI.Button.ReactSimple where

  import Graphics.UI.Interpreter.ReactSimple ()

  import Examples.Graphics.UI.Button (display)

  import React (renderComponentById)

  main = display (\comp -> renderComponentById comp "content" # void)
