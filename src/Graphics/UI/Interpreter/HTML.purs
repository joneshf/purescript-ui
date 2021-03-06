{- | `HTML` implements `Text`.
      It should also implement `ColorStyle`.
-}
module Graphics.UI.Interpreter.HTML where

  import Control.Monad.Eff (Eff())

  import Data.Foldable (intercalate)
  import Data.Maybe (Maybe(..), fromMaybe)

  import Debug.Trace (Trace(), trace)

  import Graphics.UI.Color (name2RGB)
  import Graphics.UI.Color.RGB (RGB(..))

  import qualified Graphics.UI as UI

  -- | We make an AST of `HTML`.
  -- | Though it'd be nice if this existed somewhere else.
  data HTML = HTML Style Head Body

  newtype Head = Head Title

  newtype Title = Title String

  data Body = Body Style [BodyTag]

  -- This isn't valid html.
  data BodyTag = Div  Style [BodyTag]
               | P    Style String
               | Span Style [BodyTag]
               | Text String
               | Ul   Style [ListItem]

  data ListItem = Li Style BodyTag

  newtype Pixel = Pixel Number

  newtype Style = Style StyleRec
  type StyleRec =
    { color           :: Maybe RGB
    , backgroundColor :: Maybe RGB
    , height          :: Maybe Pixel
    , width           :: Maybe Pixel
    }

  instance backgroundColorNameBody :: UI.BackgroundColorName Body where
    backgroundColor c (Body (Style style) tags) =
      Body (Style style{backgroundColor = Just $ name2RGB c}) tags

  instance backgroundColorNameBodyTag :: UI.BackgroundColorName BodyTag where
    backgroundColor c (Div  (Style style) tags) =
      Div  (Style style{backgroundColor = Just $ name2RGB c}) tags
    backgroundColor c (P    (Style style) str)  =
      P    (Style style{backgroundColor = Just $ name2RGB c}) str
    backgroundColor c (Span (Style style) str)  =
      Span (Style style{backgroundColor = Just $ name2RGB c}) str
    backgroundColor c (Text str)                =
      UI.backgroundColor c $ Span noStyle [Text str]
    backgroundColor c (Ul   (Style style) lis)  =
      Ul   (Style style{backgroundColor = Just $ name2RGB c}) lis

  instance backgroundColorNameHTML :: UI.BackgroundColorName HTML where
    backgroundColor c (HTML (Style style) head body) =
      HTML (Style style{backgroundColor = Just $ name2RGB c}) head body

  instance backgroundColorNameListItem :: UI.BackgroundColorName ListItem where
    backgroundColor c (Li (Style style) tag) =
      Li (Style style{backgroundColor = Just $ name2RGB c}) tag

  instance backgroundColorRGBBody :: UI.BackgroundColorRGB Body where
    backgroundRGB c (Body (Style style) tags) =
      Body (Style style{backgroundColor = Just c}) tags

  instance backgroundColorRGBBodyTag :: UI.BackgroundColorRGB BodyTag where
    backgroundRGB c (Div  (Style style) tags) =
      Div  (Style style{backgroundColor = Just c}) tags
    backgroundRGB c (P    (Style style) str)  =
      P    (Style style{backgroundColor = Just c}) str
    backgroundRGB c (Span (Style style) str)  =
      Span (Style style{backgroundColor = Just c}) str
    backgroundRGB c (Text str)                =
      UI.backgroundRGB c $ Span noStyle [Text str]
    backgroundRGB c (Ul   (Style style) lis)  =
      Ul   (Style style{backgroundColor = Just c}) lis

  instance backgroundColorRGBHTML :: UI.BackgroundColorRGB HTML where
    backgroundRGB c (HTML (Style style) head body) =
      HTML (Style style{backgroundColor = Just c}) head body

  instance backgroundColorRGBListItem :: UI.BackgroundColorRGB ListItem where
    backgroundRGB c (Li (Style style) tag) =
      Li (Style style{backgroundColor = Just c}) tag

  instance colorNameBody :: UI.ColorName Body where
    color c (Body (Style style) tags) =
      Body (Style style{color = Just $ name2RGB c}) tags

  instance colorNameBodyTag :: UI.ColorName BodyTag where
    color c (Div  (Style style) tags) =
      Div  (Style style{color = Just $ name2RGB c}) tags
    color c (P    (Style style) str)  =
      P    (Style style{color = Just $ name2RGB c}) str
    color c (Span (Style style) str)  =
      Span (Style style{color = Just $ name2RGB c}) str
    color c (Text str)                =
      UI.color c $ Span noStyle [Text str]
    color c (Ul   (Style style) lis)  =
      Ul   (Style style{color = Just $ name2RGB c}) lis

  instance colorNameHTML :: UI.ColorName HTML where
    color c (HTML (Style style) head body) =
      HTML (Style style{color = Just $ name2RGB c}) head body

  instance colorNameListItem :: UI.ColorName ListItem where
    color c (Li (Style style) tag) =
      Li (Style style{color = Just $ name2RGB c}) tag

  instance colorRGBBody :: UI.ColorRGB Body where
    rgb c (Body (Style style) tags) =
      Body (Style style{color = Just c}) tags

  instance colorRGBBodyTag :: UI.ColorRGB BodyTag where
    rgb c (Div  (Style style) tags) =
      Div  (Style style{color = Just c}) tags
    rgb c (P    (Style style) str)  =
      P    (Style style{color = Just c}) str
    rgb c (Span (Style style) str)  =
      Span (Style style{color = Just c}) str
    rgb c (Text str)                =
      UI.rgb c $ Span noStyle [Text str]
    rgb c (Ul   (Style style) lis)  =
      Ul   (Style style{color = Just c}) lis

  instance colorRGBHTML :: UI.ColorRGB HTML where
    rgb c (HTML (Style style) head body) =
      HTML (Style style{color = Just c}) head body

  instance colorRGBListItem :: UI.ColorRGB ListItem where
    rgb c (Li (Style style) tag) =
      Li (Style style{color = Just c}) tag

  instance groupHorizontalBodyTag :: UI.GroupHorizontal BodyTag where
    groupHorizontal tags = Div noStyle [Span noStyle tags]

  instance groupVerticalBodyTag :: UI.GroupVertical BodyTag where
    groupVertical tags = Div noStyle [Div noStyle tags]

  instance heightBody :: UI.Height Body where
    height h (Body (Style style) tags) =
      Body (Style style{height = Just $ Pixel h}) tags

  instance heightBodyTag :: UI.Height BodyTag where
    height h (Div (Style style) tags)  =
      Div (Style style{height = Just $ Pixel h}) tags
    height h (P (Style style) tags)    =
      P (Style style{height = Just $ Pixel h}) tags
    height h (Span (Style style) tags) =
      Span (Style style{height = Just $ Pixel h}) tags
    height _ t@(Text _)                = t
    height h (Ul (Style style) tags)   =
      Ul (Style style{height = Just $ Pixel h}) tags

  instance heightHTML :: UI.Height HTML where
    height h (HTML (Style style) head body) =
      HTML (Style style{height = Just $ Pixel h}) head body

  instance heightListItem :: UI.Height ListItem where
    height h (Li (Style style) tags) =
      Li (Style style{height = Just $ Pixel h}) tags

  instance listBodyTag :: UI.List BodyTag where
    list = Ul noStyle <<< ((Li noStyle) <$>)

  instance textHTML :: UI.Text HTML where
    text str = HTML noStyle (Head $ Title "") (Body noStyle [UI.text str])

  instance textBodyTag :: UI.Text BodyTag where
    text = Text

  instance titleHTML :: UI.Title HTML where
    title t (HTML style head body) = HTML style (UI.title t head) body

  instance titleHead :: UI.Title Head where
    title t (Head t') = Head $ UI.title t t'

  instance titleTitle :: UI.Title Title where
    title t _ = Title t

  instance widthBody :: UI.Width Body where
    width w (Body (Style style) tags) =
      Body (Style style{width = Just $ Pixel w}) tags

  instance widthBodyTag :: UI.Width BodyTag where
    width w (Div (Style style) tags)  =
      Div (Style style{width = Just $ Pixel w}) tags
    width w (P (Style style) tags)    =
      P (Style style{width = Just $ Pixel w}) tags
    width w (Span (Style style) tags) =
      Span (Style style{width = Just $ Pixel w}) tags
    width _ t@(Text _)                = t
    width w (Ul (Style style) tags)   =
      Ul (Style style{width = Just $ Pixel w}) tags

  instance widthHTML :: UI.Width HTML where
    width w (HTML (Style style) head body) =
      HTML (Style style{width = Just $ Pixel w}) head body

  instance widthListItem :: UI.Width ListItem where
    width w (Li (Style style) tags) =
      Li (Style style{width = Just $ Pixel w}) tags

  body' :: [BodyTag] -> Body
  body' = Body noStyle

  html' :: Body -> HTML
  html' = HTML noStyle $ Head $ Title ""

  noStyle :: Style
  noStyle = Style
    { backgroundColor: Nothing
    , color: Nothing
    , height: Nothing
    , width: Nothing
    }

  printHTML :: forall eff. HTML -> Eff (trace :: Trace | eff) Unit
  printHTML = render' >>> trace

  -- | A little helper function to generate properly indented strings.
  -- | This should be done more efficiently though.
  indent :: Number -> String -> String
  indent n str
    | n < 1     = str
    | otherwise = indent (n - 1) (" " ++ str)

  -- | A type class for `Render`ing arbitrary `HTML` tags
  class Render tag where
    render :: Number -> tag -> String

  render' :: forall tag. (Render tag) => tag -> String
  render' = render 0

  instance renderHTML :: Render HTML where
    render n (HTML style head body) = indent n "<html" ++ render' style ++ ">"
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
    render n (Body style tags) = indent n "<body" ++ render' style ++ ">"
                              ++ "\n"
                              ++ render (n + 2) tags
                              ++ "\n"
                              ++ indent n "</body>"

  instance renderBodyTag :: Render BodyTag where
    render n (Div  style tags)  = indent n "<div" ++ render' style ++ ">"
                               ++ "\n"
                               ++ render (n + 2) tags
                               ++ "\n"
                               ++ indent n "</div>"
    render n (P    style str)   = indent n "<p" ++ render' style ++ ">"
                               ++ "\n"
                               ++ render (n + 2) str
                               ++ "\n"
                               ++ indent n "</p>"
    render n (Span style tags)  = indent n "<span" ++ render' style ++ ">"
                               ++ "\n"
                               ++ render (n + 2) tags
                               ++ "\n"
                               ++ indent n "</span>"
    render n (Text str)         = indent n str
    render n (Ul   style items) = indent n "<ul" ++ render' style ++ ">"
                               ++ "\n"
                               ++ render (n + 2) items
                               ++ "\n"
                               ++ indent n "</ul>"

  instance renderListItem :: Render ListItem where
    render n (Li style item) = indent n "<li" ++ render' style ++ ">"
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

  -- TODO: This is ugly as all get out. Clean this up.
  instance renderStyle :: Render Style where
    render _ (Style style) = fromMaybe ""
      $  (("background-color: " ++) <<< render' <$> style.backgroundColor)
      ++ (("color: " ++)            <<< render' <$> style.color)
      ++ (("height: " ++)           <<< render' <$> style.height)
      ++ (("width: " ++)            <<< render' <$> style.width)
      <#> \s -> " style=\"" ++ s ++ "\""

  instance renderRGB :: Render RGB where
    render _ (RGB {red = r, green = g, blue = b}) =
      "rgb(" ++ show r ++ ", " ++ show g ++ ", " ++ show b ++ "); "

  instance renderPixel :: Render Pixel where
    render _ (Pixel px) = show px ++ "px;"
