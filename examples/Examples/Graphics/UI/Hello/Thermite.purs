{- |  We interpret the `hello` UI as a `Thermite` component.
-}
module Examples.Graphics.UI.Hello.Thermite where

  import Graphics.UI.Interpreter.Thermite ()

  import Examples.Graphics.UI.Hello (hello)

  import Thermite (render)

  main = render hello unit
