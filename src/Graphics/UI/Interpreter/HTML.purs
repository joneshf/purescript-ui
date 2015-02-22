{- | `HTML` implements `Text`.
      It should also implement `ColorStyle`.
-}
module Graphics.UI.Interpreter.HTML where

  import Control.Monad.Eff (Eff())

  import Data.Either (Either(..))
  import Data.Foldable (intercalate)
  import Data.Maybe (Maybe(..), fromMaybe)
  import Data.Profunctor (dimap)
  import Data.Tuple (Tuple(..), uncurry)

  import Debug.Trace (Trace(), trace)

  import qualified Graphics.UI as UI
  import Graphics.UI.Color (name2RGB)
  import Graphics.UI.Color.RGB (RGB(..))

  import Optic.Core ((?~), (..), Lens(), Prism(), LensP(), PrismP(), prism)
  import Optic.Refractor.Lens (_1)
  import Optic.Totally

  -- | We make an AST of `HTML`.
  -- | Though it'd be nice if this existed somewhere else.
  data HTML = HTML Head Body

  newtype Head = Head Title

  newtype Title = Title String

  data Body = Body Style [BodyTag]

  data BodyTag = P  Style String
               | Ul Style [ListItem]

  data ListItem = Li Style BodyTag

  newtype Style = Style StyleRec
  type StyleRec = {color :: Maybe RGB}

  noStyle :: Style
  noStyle = Style {color: Nothing}

  printHTML :: forall eff. HTML -> Eff (trace :: Trace | eff) Unit
  printHTML = render 0 >>> trace

  _P :: forall a. Prism BodyTag BodyTag (Tuple Style String) a
  _P = prism (\_ -> P noStyle "") (\bt -> case bt of
    P  style string -> Right $ Tuple style string
    _               -> Left bt)

  _Ul :: forall a. Prism BodyTag BodyTag (Tuple Style [ListItem]) a
  _Ul = prism (\_ -> Ul noStyle []) (\bt -> case bt of
    Ul style items -> Right $ Tuple style items
    _              -> Left bt)

  _Style :: LensP Style StyleRec
  _Style f (Style rec) = f rec <#> Style

  color :: forall a b. LensP {color :: a | _} a
  color f o = f o.color <#> o{color = _}

  instance totallyBodyTag :: Totally BodyTag where
    totally = undefined

  foreign import undefined :: forall a. a

  instance colorNameBody :: UI.ColorName Body where
    color c (Body (Style style) tags) =
      Body (Style {color: Just $ name2RGB c}) tags

  instance colorNameBodyTag :: UI.ColorName BodyTag where
    color c = totally
      # like _P  ((uncurry P) <<< setStyle c)
      # like _Ul ((uncurry Ul) <<< setStyle c)

  -- Apparently something goes wrong when in an instance,
  -- and the type signature is monomorphic
  setStyle c = _1.._Style..color ?~ name2RGB c

  instance colorNameHTML :: UI.ColorName HTML where
    color c (HTML head body) = HTML head $ UI.color c body

  instance colorNameListItem :: UI.ColorName ListItem where
    color c (Li (Style style) tag) = Li (Style {color: Just $ name2RGB c}) tag

  instance listBodyTag :: UI.List BodyTag where
    list = Ul noStyle <<< ((Li noStyle) <$>)

  instance textHTML :: UI.Text HTML where
    text str = HTML (Head $ Title "") (Body noStyle [UI.text str])

  instance textBodyTag :: UI.Text BodyTag where
    text = P noStyle

  -- | A little helper function to generate properly indented strings.
  -- | This should be done more efficiently though.
  indent :: Number -> String -> String
  indent n str
    | n < 1     = str
    | otherwise = indent (n - 1) (" " ++ str)

  -- | A type class for `Render`ing arbitrary `HTML` tags
  class Render tag where
    render :: Number -> tag -> String

  instance renderHTML :: Render HTML where
    render n (HTML head body) = indent n "<html>"
                             ++ "\n"
                             ++ render (n + 2) head
                             ++ "\n"
                             ++ render (n + 2) body
                             ++ "\n"
                             ++ indent n "</html>"

  instance renderHead :: Render Head where
    render n (Head title) = indent n "<head>"
                         ++ "\n"
                         ++ render (n + 2) title
                         ++ "\n"
                         ++ indent n "</head>"

  instance renderTitle :: Render Title where
    render n (Title title) = indent n "<title>"
                          ++ "\n"
                          ++ render (n + 2) title
                          ++ "\n"
                          ++ indent n "</title>"

  instance renderBody :: Render Body where
    render n (Body style tags) = indent n "<body" ++ render 0 style ++ ">"
                              ++ "\n"
                              ++ render (n + 2) tags
                              ++ "\n"
                              ++ indent n "</body>"

  instance renderBodyTag :: Render BodyTag where
    render n (P style str) = indent n "<p" ++ render 0 style ++ ">"
                          ++ "\n"
                          ++ render (n + 2) str
                          ++ "\n"
                          ++ indent n "</p>"
    render n (Ul style items) = indent n "<ul" ++ render 0 style ++ ">"
                             ++ "\n"
                             ++ render (n + 2) items
                             ++ "\n"
                             ++ indent n "</ul>"

  instance renderListItem :: Render ListItem where
    render n (Li style item) = indent n "<li" ++ render 0 style ++ ">"
                            ++ "\n"
                            ++ render (n + 2) item
                            ++ "\n"
                            ++ indent n "</li>"

  -- | We can also render `String`s.
  instance renderString :: Render String where
    render = indent

  -- | We can render an array of things by `intercalate`ing a newline.
  instance renderArray :: (Render h) => Render [h] where
    render n hs = intercalate "\n" $ render n <$> hs

  instance renderStyle :: Render Style where
    render _ (Style style) = fromMaybe "" do
      c <- render 0 <$> style.color
      pure $ " style=\"" ++ c ++ "\""

  instance renderRGB :: Render RGB where
    render _ (RGB {red = r, green = g, blue = b}) =
      "color: rgb(" ++ show r ++ ", " ++ show g ++ ", " ++ show b ++ ");"
