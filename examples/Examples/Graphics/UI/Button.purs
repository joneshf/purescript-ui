module Examples.Graphics.UI.Button where

  import Control.Monad.Eff

  import Graphics.UI

  import Signal
  import Signal.Channel

  nums :: Eff (chan :: Chan | _) (Channel Number)
  nums = channel 0

  subbed :: Eff (chan :: Chan | _) (Signal Number)
  subbed = subscribe <$> nums

  uno :: forall g. (Button g (Eff (chan :: Chan | _) Unit)) => g
  uno = button "1" (nums >>= (`send` 1))

  onu :: forall g. (Text g) => Eff (chan :: Chan | _) (Signal g)
  onu = do
    num <- subbed
    pure $ (text <<< show) <$> num

  ui :: forall g
     .  (Button g (Eff (chan :: Chan | _) Unit), GroupHorizontal g, Text g)
     => Eff (chan :: Chan | _) (Signal g)
  ui = do
    onu' <- onu
    pure (onu' <#> \o -> groupHorizontal [uno, o])

  display :: forall g
          .  (Button g (Eff (chan :: Chan | _) Unit), GroupHorizontal g, Text g)
          => (g -> Eff _ Unit) -> Eff _ Unit
  display generate = do
    ui' <- ui
    runSignal $ generate <$> ui'
