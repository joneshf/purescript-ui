# Module Documentation

## Module Graphics.UI

#### `BackgroundColorName`

``` purescript
class BackgroundColorName lang where
  backgroundColor :: Name -> lang -> lang
```

We can color the representation.

#### `BackgroundColorRGB`

``` purescript
class BackgroundColorRGB lang where
  backgroundRGB :: RGB -> lang -> lang
```

We can color the representation.

#### `Button`

``` purescript
class Button lang event where
  button :: String -> event -> lang
```


#### `ColorName`

``` purescript
class ColorName lang where
  color :: Name -> lang -> lang
```

We can color the representation.

#### `ColorRGB`

``` purescript
class ColorRGB lang where
  rgb :: RGB -> lang -> lang
```

We can color the representation.

#### `GroupVertical`

``` purescript
class GroupVertical lang where
  groupVertical :: [lang] -> lang
```

We can vertically align multiple UI's

#### `GroupHorizontal`

``` purescript
class GroupHorizontal lang where
  groupHorizontal :: [lang] -> lang
```

We can horizontally align multiple UI's

#### `List`

``` purescript
class List lang where
  list :: [lang] -> lang
```

A simple list of things.

#### `Text`

``` purescript
class Text lang where
  text :: String -> lang
```

We can make some text.

#### `Title`

``` purescript
class Title lang where
  title :: String -> lang -> lang
```

We can set the title of a UI.

#### `button'`

``` purescript
button' :: forall a e lang. (Show a, Button lang e) => a -> e -> lang
```


#### `text'`

``` purescript
text' :: forall a lang. (Show a, Text lang) => a -> lang
```


#### `title'`

``` purescript
title' :: forall a lang. (Show a, Title lang) => a -> lang -> lang
```



## Module Graphics.UI.Color

#### `name2RGB`

``` purescript
name2RGB :: Name -> RGB
```



## Module Graphics.UI.Color.Name

#### `Name`

``` purescript
data Name
  = Black 
  | White 
  | Red 
  | Green 
  | Yellow 
  | Blue 
  | Purple 
```

The possible colors we can make.
Based on the first six stages of color in language by Berlin and Kay.

#### `PrismP`

``` purescript
type PrismP s a = forall f p. (Applicative f, Choice p) => p a (f a) -> p s (f s)
```


#### `_Black`

``` purescript
_Black :: PrismP Name Unit
```


#### `_White`

``` purescript
_White :: PrismP Name Unit
```


#### `_Red`

``` purescript
_Red :: PrismP Name Unit
```


#### `_Green`

``` purescript
_Green :: PrismP Name Unit
```


#### `_Yellow`

``` purescript
_Yellow :: PrismP Name Unit
```


#### `_Blue`

``` purescript
_Blue :: PrismP Name Unit
```


#### `_Purple`

``` purescript
_Purple :: PrismP Name Unit
```



## Module Graphics.UI.Color.RGB

#### `RGB`

``` purescript
newtype RGB
  = RGB RGBRec
```


#### `RGBRec`

``` purescript
type RGBRec = { blue :: Number, green :: Number, red :: Number }
```


#### `LensP`

``` purescript
type LensP s a = forall f. (Functor f) => (a -> f a) -> s -> f s
```


#### `_RGB`

``` purescript
_RGB :: LensP RGB RGBRec
```


#### `red`

``` purescript
red :: LensP { red :: Number | _ } Number
```


#### `green`

``` purescript
green :: LensP { green :: Number | _ } Number
```


#### `blue`

``` purescript
blue :: LensP { blue :: Number | _ } Number
```



## Module Graphics.UI.Interpreter.HTML

#### `HTML`

``` purescript
data HTML
  = HTML Head Body
```

We make an AST of `HTML`.
Though it'd be nice if this existed somewhere else.

#### `Head`

``` purescript
newtype Head
  = Head Title
```


#### `Title`

``` purescript
newtype Title
  = Title String
```


#### `Body`

``` purescript
data Body
  = Body Style [BodyTag]
```


#### `BodyTag`

``` purescript
data BodyTag
  = Div Style [BodyTag]
  | P Style String
  | Span Style [BodyTag]
  | Text String
  | Ul Style [ListItem]
```

#### `ListItem`

``` purescript
data ListItem
  = Li Style BodyTag
```


#### `Style`

``` purescript
newtype Style
  = Style StyleRec
```


#### `StyleRec`

``` purescript
type StyleRec = { backgroundColor :: Maybe RGB, color :: Maybe RGB }
```


#### `backgroundColorNameBody`

``` purescript
instance backgroundColorNameBody :: UI.BackgroundColorName Body
```


#### `backgroundColorNameBodyTag`

``` purescript
instance backgroundColorNameBodyTag :: UI.BackgroundColorName BodyTag
```


#### `backgroundColorNameHTML`

``` purescript
instance backgroundColorNameHTML :: UI.BackgroundColorName HTML
```


#### `backgroundColorNameListItem`

``` purescript
instance backgroundColorNameListItem :: UI.BackgroundColorName ListItem
```


#### `colorNameBody`

``` purescript
instance colorNameBody :: UI.ColorName Body
```


#### `colorNameBodyTag`

``` purescript
instance colorNameBodyTag :: UI.ColorName BodyTag
```


#### `colorNameHTML`

``` purescript
instance colorNameHTML :: UI.ColorName HTML
```


#### `colorNameListItem`

``` purescript
instance colorNameListItem :: UI.ColorName ListItem
```


#### `backgroundColorRGBBody`

``` purescript
instance backgroundColorRGBBody :: UI.BackgroundColorRGB Body
```


#### `backgroundColorRGBBodyTag`

``` purescript
instance backgroundColorRGBBodyTag :: UI.BackgroundColorRGB BodyTag
```


#### `backgroundColorRGBHTML`

``` purescript
instance backgroundColorRGBHTML :: UI.BackgroundColorRGB HTML
```


#### `backgroundColorRGBListItem`

``` purescript
instance backgroundColorRGBListItem :: UI.BackgroundColorRGB ListItem
```


#### `colorRGBBody`

``` purescript
instance colorRGBBody :: UI.ColorRGB Body
```


#### `colorRGBBodyTag`

``` purescript
instance colorRGBBodyTag :: UI.ColorRGB BodyTag
```


#### `colorRGBHTML`

``` purescript
instance colorRGBHTML :: UI.ColorRGB HTML
```


#### `colorRGBListItem`

``` purescript
instance colorRGBListItem :: UI.ColorRGB ListItem
```


#### `groupHorizontalBodyTag`

``` purescript
instance groupHorizontalBodyTag :: UI.GroupHorizontal BodyTag
```


#### `groupVerticalBodyTag`

``` purescript
instance groupVerticalBodyTag :: UI.GroupVertical BodyTag
```


#### `listBodyTag`

``` purescript
instance listBodyTag :: UI.List BodyTag
```


#### `textHTML`

``` purescript
instance textHTML :: UI.Text HTML
```


#### `textBodyTag`

``` purescript
instance textBodyTag :: UI.Text BodyTag
```


#### `titleHTML`

``` purescript
instance titleHTML :: UI.Title HTML
```


#### `titleHead`

``` purescript
instance titleHead :: UI.Title Head
```


#### `titleTitle`

``` purescript
instance titleTitle :: UI.Title Title
```


#### `body'`

``` purescript
body' :: [BodyTag] -> Body
```


#### `html'`

``` purescript
html' :: Body -> HTML
```


#### `noStyle`

``` purescript
noStyle :: Style
```


#### `printHTML`

``` purescript
printHTML :: forall eff. HTML -> Eff (trace :: Trace | eff) Unit
```


#### `indent`

``` purescript
indent :: Number -> String -> String
```

A little helper function to generate properly indented strings.
This should be done more efficiently though.

#### `Render`

``` purescript
class Render tag where
  render :: Number -> tag -> String
```

A type class for `Render`ing arbitrary `HTML` tags

#### `render'`

``` purescript
render' :: forall tag. (Render tag) => tag -> String
```


#### `renderHTML`

``` purescript
instance renderHTML :: Render HTML
```


#### `renderHead`

``` purescript
instance renderHead :: Render Head
```


#### `renderTitle`

``` purescript
instance renderTitle :: Render Title
```


#### `renderBody`

``` purescript
instance renderBody :: Render Body
```


#### `renderBodyTag`

``` purescript
instance renderBodyTag :: Render BodyTag
```


#### `renderListItem`

``` purescript
instance renderListItem :: Render ListItem
```


#### `renderString`

``` purescript
instance renderString :: Render String
```

We can also render `String`s.

#### `renderArray`

``` purescript
instance renderArray :: (Render h) => Render [h]
```

We can render an array of things by `intercalate`ing a newline.

#### `renderStyle`

``` purescript
instance renderStyle :: Render Style
```

#### `renderRGB`

``` purescript
instance renderRGB :: Render RGB
```



## Module Graphics.UI.Interpreter.ReactSimple

#### `buttonComponent`

``` purescript
instance buttonComponent :: Button R.Component (Eff eff Unit)
```


#### `groupHorizontalComponent`

``` purescript
instance groupHorizontalComponent :: GroupHorizontal R.Component
```


#### `groupVerticalComponent`

``` purescript
instance groupVerticalComponent :: GroupVertical R.Component
```


#### `textComponent`

``` purescript
instance textComponent :: Text R.Component
```



## Module Graphics.UI.Interpreter.String

#### `textString`

``` purescript
instance textString :: Text String
```


#### `stringify`

``` purescript
stringify :: String -> String
```

We interpret `String` fairly easily here. It's just identity.


## Module Graphics.UI.Interpreter.Terminal

#### `Terminal`

``` purescript
newtype Terminal
  = Terminal String
```


#### `runTerminal`

``` purescript
runTerminal :: Terminal -> String
```


#### `printTerminal`

``` purescript
printTerminal :: forall eff. Terminal -> Eff (trace :: Trace | eff) Unit
```


#### `textTerminal`

``` purescript
instance textTerminal :: Text Terminal
```


#### `colorNameTerminal`

``` purescript
instance colorNameTerminal :: ColorName Terminal
```

We use ANSI color codes.


## Module Graphics.UI.Interpreter.Thermite

#### `buttonThermiteComponentClass`

``` purescript
instance buttonThermiteComponentClass :: Button (T.ComponentClass props eff) (T.MouseEvent -> action)
```


#### `buttonThermiteComponentClassEff`

``` purescript
instance buttonThermiteComponentClassEff :: Button (T.ComponentClass props eff) (Eff eff a)
```


#### `groupHorizontalThermiteHtml`

``` purescript
instance groupHorizontalThermiteHtml :: GroupHorizontal (T.Html action)
```


#### `textThermiteHtml`

``` purescript
instance textThermiteHtml :: Text (T.Html action)
```

#### `textThermiteComponentClass`

``` purescript
instance textThermiteComponentClass :: Text (T.ComponentClass props eff)
```




