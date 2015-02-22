{- | `Terminal` implements `Text` and `ColorName`.
      This is an ANSI Terminal interpreter.
-}
module Graphics.UI.Interpreter.Terminal where

  import Control.Monad.Eff (Eff())

  import Debug.Trace (Trace(), trace)

  import Graphics.UI (Text, text, ColorName, color)
  import Graphics.UI.Color.Name (Name(..))

  newtype Terminal = Terminal String

  runTerminal :: Terminal -> String
  runTerminal (Terminal str) = str

  printTerminal :: forall eff. Terminal -> Eff (trace :: Trace | eff) Unit
  printTerminal = runTerminal >>> trace

  instance textTerminal :: Text Terminal where
    text = Terminal

  -- | We use ANSI color codes.
  instance colorNameTerminal :: ColorName Terminal where
    color Black  (Terminal str) = Terminal $ "\x1b[30m" ++ str ++ "\x1b[39;49m"
    color White  (Terminal str) = Terminal $ "\x1b[37m" ++ str ++ "\x1b[39;49m"
    color Red    (Terminal str) = Terminal $ "\x1b[31m" ++ str ++ "\x1b[39;49m"
    color Green  (Terminal str) = Terminal $ "\x1b[32m" ++ str ++ "\x1b[39;49m"
    color Yellow (Terminal str) = Terminal $ "\x1b[33m" ++ str ++ "\x1b[39;49m"
    color Blue   (Terminal str) = Terminal $ "\x1b[34m" ++ str ++ "\x1b[39;49m"
    color Purple (Terminal str) = Terminal $ "\x1b[35m" ++ str ++ "\x1b[39;49m"
