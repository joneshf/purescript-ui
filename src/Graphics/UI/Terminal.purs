{- | `Terminal` implements `Text` and `ColorStyle`.
      This is an ANSI Terminal interpreter.
-}
module Graphics.UI.Terminal where

  import Graphics.UI

  newtype Terminal = Terminal String

  runTerminal :: Terminal -> String
  runTerminal (Terminal str) = str

  instance textTerminal :: Text Terminal where
    text = Terminal

  -- | We use ANSI color codes.
  instance colorStyleTerminal :: ColorStyle Terminal where
    color Black (Terminal str) = Terminal $ "\x1b[30m" ++ str ++ "\x1b[39;49m"
    color White (Terminal str) = Terminal $ "\x1b[37m" ++ str ++ "\x1b[39;49m"
    color Red   (Terminal str) = Terminal $ "\x1b[31m" ++ str ++ "\x1b[39;49m"
