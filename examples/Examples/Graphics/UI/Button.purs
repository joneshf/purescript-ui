{-  | We're recreating the example from `purescript-thermite`.
    | However, we're using `purescript-signal` for our logic,
    | and letting any interpreter create the display.
-}
module Examples.Graphics.UI.Button (Display, display) where

  import Control.Monad.Eff (Eff())

  import Data.Array (snoc)

  import Graphics.UI
    ( Button, button
    , GroupHorizontal, groupHorizontal
    , GroupVertical, groupVertical
    , Text, text
    )

  import Signal (Signal(), foldp, runSignal)
  import Signal.Channel (Chan(), Channel(), channel, send, subscribe)

  {-  | Something to note here.
      |
      | * We're using the `Monad` instance for functions
      |   so we don't have to pass around the argument.
      |   We could have used `Reader` here, but no point in another dependency.
  -}

  {-  | We create a "constraint synonym",
      | so that we don't have to pass around this laundry list of constraints.
  -}
  class ( Button g (Eff (chan :: Chan) Unit), GroupHorizontal g, GroupVertical g
        , Text g) <= Display g

  -- | Create a channel for the numbers.
  nums :: Eff (chan :: Chan | _) (Channel Number)
  nums = channel 0

  -- Helper for buttons.
  augment :: forall g. (Display g) => String -> Number -> Channel Number -> g
  augment label n = do
    message <- flip send n
    pure $ button label message

  -- | The increment button.
  increment :: forall g. (Display g) => Channel Number -> g
  increment = augment "Increment" 1

  -- | The decrement button.
  decrement :: forall g. (Display g) => Channel Number -> g
  decrement = augment "Decrement" (- 1)

  -- | Display the value in the channel.
  value :: forall g. (Display g) => Channel Number -> Signal g
  value = do
    sig <- foldp (+) 0 <<< subscribe
    pure $ sig <#> \n -> text $ "Value: " ++ show n

  -- | Create our actual ui.
  ui :: forall g. (Display g) => Channel Number -> Signal g
  ui = do
    valueSig <- value
    decrementUI <- decrement
    incrementUI <- increment
    pure $ valueSig <#> \val ->
      groupVertical [ val
                    , groupHorizontal [incrementUI, decrementUI]
                    ]

  -- | Wire together the ui, channel, and renderer.
  display :: forall g. (Display g) => (g -> Eff _ Unit) -> Eff _ Unit
  display renderer = do
    numsChan <- nums
    runSignal $ renderer <$> ui numsChan
