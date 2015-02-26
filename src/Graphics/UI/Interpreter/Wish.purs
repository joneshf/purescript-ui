{- | This is a very primitive Tk Interpreter that generates wish scripts.
-}
module Graphics.UI.Interpreter.Wish where

  import Control.Monad.Eff (Eff())
  import Control.Monad.Reader.Class (ask, local)
  import Control.Monad.RWS.Trans (RWST(), evalRWST)
  import Control.Monad.State.Class (state)
  import Control.Monad.Writer.Class (tell)

  import Data.Array (snoc)
  import Data.Foldable (intercalate, mconcat)
  import Data.Maybe (Maybe(..), fromMaybe)
  import Data.Monoid (Monoid)
  import Data.Traversable (for)
  import Data.Tuple (Tuple(..), snd)

  import Debug.Trace (Trace(), trace)

  import Graphics.UI
    ( BackgroundColorName, backgroundColor
    , ColorName, color
    , GroupHorizontal
    , GroupVertical
    , Text
    )
  import Graphics.UI.Color (name2Hex)
  import Graphics.UI.Color.Hex (Hex(..))

  import Optic.Core (Lens(), LensP(), PrismP(), (..), (?~), prism')

  type Hierarchy = [String]
  type Names = [String]

  data Side = T | L | R | B

  data Wish = GM GeometryManager
            | Frame Hierarchy [Wish] Options
            | Label Hierarchy String Options

  data GeometryManager = Pack [Wish] Side

  newtype Options = Options OptionsRec
  type OptionsRec =
    { background :: Maybe Hex
    , foreground :: Maybe Hex
    }

  noOptions :: Options
  noOptions = Options
    { background: Nothing
    , foreground: Nothing
    }

  type WishEnv = RWST Wish String Number

  instance backgroundColorNameWish :: BackgroundColorName Wish where
    backgroundColor c (Frame h ws opts) =
      Frame h ws (opts # _Options..background ?~ name2Hex c)
    backgroundColor c (GM gm)           = GM $ backgroundColor c gm
    backgroundColor c (Label h s opts)  =
      Label h s (opts # _Options..background ?~ name2Hex c)

  instance backgroundColorNameGeometryManager :: BackgroundColorName GeometryManager where
    backgroundColor c (Pack ws side) = Pack (backgroundColor c <$> ws) side

  instance colorNameWish :: ColorName Wish where
    color c (GM gm)           = GM $ color c gm
    color c (Label h s opts)  =
      Label h s (opts # _Options..foreground ?~ name2Hex c)
    color c (Frame h ws opts) = Frame h (color c <$> ws) opts

  instance colorNameGeometryManager :: ColorName GeometryManager where
    color c (Pack ws side) = Pack (color c <$> ws) side

  instance groupHorizontalWish :: GroupHorizontal Wish where
    groupHorizontal ws = GM $ Pack [Frame [""] (fixSide L ws) noOptions] T

  instance groupVerticalWish :: GroupVertical Wish where
    groupVertical ws = GM $ Pack [Frame [""] (fixSide T ws) noOptions] T

  instance textWish :: Text Wish where
    text str = GM $ Pack [Label [""] str noOptions] T

  fixHierarchy :: String -> [Wish] -> [Wish]
  fixHierarchy h ws = go <$> ws
    where
      go (GM (Pack ws' s))   = GM $ Pack (go <$> ws') s
      go (Frame hs ws' opts) = Frame (hs `snoc` h) (go <$> ws') opts
      go (Label hs str opts) = Label (hs `snoc` h) str opts

  fixSide :: Side -> [Wish] -> [Wish]
  fixSide s ws = go <$> ws
    where
      go (Frame h ws os)  = Frame h (go <$> ws) os
      go (GM (Pack ws _)) = GM (Pack ws s)
      go t                = t

  printWish :: Wish -> Eff (trace :: Trace | _) Unit
  printWish w = evalRWST renderWish w 0 >>= snd >>> trace

  renderOptions :: Options -> String
  renderOptions (Options rec) = fromMaybe ""
    $  (rec.background <#> \bg -> " -background " ++ show bg)
    ++ (rec.foreground <#> \fg -> " -foreground " ++ show fg)

  renderPack :: forall m. (Monad m) => Names -> Side -> WishEnv m _
  renderPack names side = for names \name ->
    tellLn $ "pack " ++ name ++ " -side " ++ renderSide side

  renderShebang :: String
  renderShebang = "#!/usr/bin/wish"

  renderSide :: Side -> String
  renderSide T = "top"
  renderSide L = "left"
  renderSide R = "right"
  renderSide B = "bottom"

  renderText :: String -> String
  renderText str = " -text \"" ++ str ++ "\""

  -- | Generate a simple shell script.
  renderWish :: forall m. (Monad m) => WishEnv m Names
  renderWish = do
    tellLn renderShebang
    renderWish'

  renderWish' :: forall m. (Monad m) => WishEnv m Names
  renderWish' = ask >>= \w -> case w of
    Frame hier ts opts -> do
      ident <- modifies (+ 1)
      let name = "frame" ++ show ident
      let path = intercalate "." $ hier `snoc` name
      tellLn $ "frame " ++ path ++ renderOptions opts
      for (fixHierarchy name ts) \w -> local (const w) renderWish'
      pure [path]
    GM (Pack ws side) -> do
      names <- for ws \w' -> local (const w') renderWish'
      renderPack (mconcat names) side
      pure []
    Label hier text opts -> do
      ident <- modifies (+ 1)
      let name = "label" ++ show ident
      let path = intercalate "." $ hier `snoc` name
      tellLn $ "label " ++ path ++ renderText text ++ renderOptions opts
      pure [path]

  -- | RWS stuff

  modifies :: forall m w. (Monad m, Monoid w) => _ -> RWST _ w _ m _
  modifies f = state \s -> Tuple s (f s)

  tellLn :: forall m w. (Monad m, Monoid w) => _ -> RWST _ w _ m Unit
  tellLn str = tell $ str ++ "\n"

  -- | Optic stuff

  _Options :: LensP Options OptionsRec
  _Options f (Options rec) = f rec <#> Options

  background :: forall a b. Lens {background :: a | _} {background :: b | _} a b
  background f o = f o.background <#> o{background = _}

  foreground :: forall a b. Lens {foreground :: a | _} {foreground :: b | _} a b
  foreground f o = f o.foreground <#> o{foreground = _}

  hierarchy :: forall a b. Lens {hierarchy :: a | _} {hierarchy :: b | _} a b
  hierarchy f o = f o.hierarchy <#> o{hierarchy = _}

  ws :: forall a b. Lens {ws :: a | _} {ws :: b | _} a b
  ws f o = f o.ws <#> o{ws = _}

  _Frame :: PrismP Wish {hierarchy :: Hierarchy, wishes :: [Wish], options :: Options}
  _Frame = prism' (\o -> Frame o.hierarchy o.wishes o.options)
                  (\w -> case w of
                    Frame h w o -> Just {hierarchy: h, wishes: w, options: o}
                    _           -> Nothing
                  )

  _GM :: PrismP Wish GeometryManager
  _GM = prism' GM (\w -> case w of
                    GM gm -> Just gm
                    _     -> Nothing
                  )

  _Label :: PrismP Wish {hierarchy :: Hierarchy, label :: String, options :: Options}
  _Label = prism' (\o -> Label o.hierarchy o.label o.options)
                  (\w -> case w of
                    Label h l o -> Just {hierarchy: h, label: l, options: o}
                    _           -> Nothing
                  )

  _Pack :: PrismP GeometryManager {wishes :: [Wish], side :: Side}
  _Pack = prism' (\o -> Pack o.wishes o.side)
                 (\w -> case w of
                   Pack w s -> Just {wishes: w, side: s}
                   _        -> Nothing
                 )
