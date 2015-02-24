{- |  We interpret the `button` UI as a `Thermite` component.
-}
module Examples.Graphics.UI.Button.Thermite where

  import Graphics.UI.Interpreter.Thermite ()

  import Examples.Graphics.UI.Button (display, uno)

  import Thermite (render)

  main = display (\g -> render g unit)
