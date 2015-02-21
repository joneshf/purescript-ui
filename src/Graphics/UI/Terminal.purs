{- | `Terminal` implements `Text` and `ColorSimple`.
      This is an ANSI Terminal interpreter.
-}
module Graphics.UI.Terminal where

  import Control.Monad.Eff

  import Debug.Trace

  import Graphics.UI

  newtype Terminal = Terminal String

  runTerminal :: Terminal -> String
  runTerminal (Terminal str) = str

  printTerminal :: forall eff. Terminal -> Eff (trace :: Trace | eff) Unit
  printTerminal = runTerminal >>> trace

  instance textTerminal :: Text Terminal where
    text = Terminal

  -- | We use ANSI color codes.
  instance colorSimpleTerminal :: ColorSimple Terminal where
    color Black  (Terminal str) = Terminal $ "\x1b[30m" ++ str ++ "\x1b[39;49m"
    color White  (Terminal str) = Terminal $ "\x1b[37m" ++ str ++ "\x1b[39;49m"
    color Red    (Terminal str) = Terminal $ "\x1b[31m" ++ str ++ "\x1b[39;49m"
    color Green  (Terminal str) = Terminal $ "\x1b[32m" ++ str ++ "\x1b[39;49m"
    color Yellow (Terminal str) = Terminal $ "\x1b[33m" ++ str ++ "\x1b[39;49m"
    color Blue   (Terminal str) = Terminal $ "\x1b[34m" ++ str ++ "\x1b[39;49m"
    color Brown  (Terminal str) = Terminal $ "\x1b[33m" ++ str ++ "\x1b[39;49m"
