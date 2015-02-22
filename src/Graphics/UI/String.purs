{- | `String` can only implements `Text`.
      There's no way to `Color` a raw string.
-}
module Graphics.UI.String where

  import Graphics.UI (Text, text)

  instance textString :: Text String where
    text = id

  -- | We interpret `String` fairly easily here. It's just identity.
  stringify :: String -> String
  stringify = id
