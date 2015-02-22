{- | `HTML` implements `Text`.
      It should also implement `ColorStyle`.
-}
module Graphics.UI.HTML where

  import Control.Monad.Eff (Eff())

  import Data.Foldable (intercalate)
  import Data.Maybe (Maybe(..), maybe)

  import Debug.Trace (Trace(), trace)

  import Graphics.UI
    ( Color(..)
    , List, list
    , Text, text
    )

  -- | We make an AST of `HTML`.
  -- | Though it'd be nice if this existed somewhere else.
  data HTML = HTML Head Body

  newtype Head = Head Title

  newtype Title = Title String

  newtype Body = Body [BodyTag]

  data BodyTag = P  Style String
               | Ul Style [ListItem]

  data ListItem = Li Style BodyTag

  newtype Style = Style {color :: Maybe RGB}

  newtype RGB = RGB {red :: Number, green :: Number, blue :: Number}

  color2RGB :: Color -> RGB
  color2RGB Black  = RGB {red: 0,   green: 0,   blue: 0}
  color2RGB White  = RGB {red: 255, green: 255, blue: 255}
  color2RGB Red    = RGB {red: 255, green: 0,   blue: 0}
  color2RGB Green  = RGB {red: 0,   green: 255, blue: 0}
  color2RGB Yellow = RGB {red: 0,   green: 255, blue: 255}
  color2RGB Blue   = RGB {red: 0,   green: 0,   blue: 255}
  color2RGB Purple = RGB {red: 255, green: 0,   blue: 255}

  instance textHTML :: Text HTML where
    text str = HTML (Head $ Title "") (Body [text str])

  instance textBodyTag :: Text BodyTag where
    text = P noStyle

  instance listBodyTag :: List BodyTag where
    list = Ul noStyle <<< ((Li noStyle) <$>)

  noStyle :: Style
  noStyle = Style {color: Nothing}

  printHTML :: forall eff. HTML -> Eff (trace :: Trace | eff) Unit
  printHTML = render 0 >>> trace

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
    render n (Body tags) = indent n "<body>"
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
    render _ (Style style) = maybe "" (render 0) style.color

  instance renderRGB :: Render RGB where
    render _ (RGB {red = r, green = g, blue = b}) =
      "rgb(" ++ show r ++ ", " ++ show g ++ ", " ++ show b ++ ")"
