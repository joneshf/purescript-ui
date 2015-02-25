{- |  We interpret the `logo` UI as a `ReactSimple` component.
-}
module Examples.Graphics.UI.Logo.ReactSimple where

  import Graphics.UI.Interpreter.ReactSimple ()

  import Examples.Graphics.UI.Logo (Logo, logo)

  import React (renderComponentById)
  import React.Types (Component())

  main = logo $ flip renderComponentById "content"

  instance logoComponent :: Logo Component
