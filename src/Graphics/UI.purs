{- | Here we specify the possible ways to build UI's. -}
module Graphics.UI where

  -- | We can make some text.
  class Text lang where
    text :: String -> lang

  -- | We can color the representation.
  class ColorStyle lang where
    color :: Color -> lang -> lang

  -- | The possible colors we can make.
  data Color = Black
             | White
             | Red

{- | `String` can only implements `Text`.
      There's no way to `Color` a raw string.
-}
module Graphics.UI.String where

  import Graphics.UI

  instance textString :: Text String where
    text = id

  -- | We interpret `String` fairly easily here. It's just identity.
  stringify :: String -> String
  stringify = id

{- | `Terminal` implements `Text` and `ColorStyle`.
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

{- | `HTML` implements `Text`.
      It should also implement `ColorStyle`.
-}
module Graphics.UI.HTML where

  import Data.Foldable

  import Graphics.UI

  -- | We make an AST of `HTML`.
  data HTML = HTML Head Body

  newtype Head = Head Title

  newtype Title = Title String

  newtype Body = Body [BodyTag]

  newtype BodyTag = P String

  instance textHTML :: Text HTML where
    text str = HTML (Head $ Title "") (Body [P str])

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
    render n (P str) = indent n "<p>"
                    ++ "\n"
                    ++ render (n + 2) str
                    ++ "\n"
                    ++ indent n "</p>"

  -- | We can also render `String`s.
  instance renderString :: Render String where
    render = indent

  -- | We can render an array of things by `intercalat`ing a newline.
  instance renderArray :: (Render h) => Render [h] where
    render n hs = intercalate "\n" $ render n <$> hs
