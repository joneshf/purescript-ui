# Module Documentation

## Module Graphics.UI

#### `Button`

``` purescript
class Button lang event where
  button :: String -> event -> lang
```

## Creation
We can interact with a UI through an event.

#### `Image`

``` purescript
class Image lang where
  image :: String -> lang
```

We can make an image UI.

#### `Text`

``` purescript
class Text lang where
  text :: String -> lang
```

We can make a text UI.

#### `GroupVertical`

``` purescript
class GroupVertical lang where
  groupVertical :: [lang] -> lang
```

## Layout
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

A simple list of UI's.

#### `Position`

``` purescript
class Position lang where
  position :: Number -> Number -> lang -> lang
```

We can explicitly position a UI.

#### `BackgroundColorName`

``` purescript
class BackgroundColorName lang where
  backgroundColor :: Name -> lang -> lang
```

## Styling
#### Color
We can color background of the UI.

#### `BackgroundColorRGB`

``` purescript
class BackgroundColorRGB lang where
  backgroundRGB :: RGB -> lang -> lang
```

We can color background of the UI.

#### `ColorName`

``` purescript
class ColorName lang where
  color :: Name -> lang -> lang
```

We can color the UI.

#### `ColorRGB`

``` purescript
class ColorRGB lang where
  rgb :: RGB -> lang -> lang
```

We can color the UI.

#### `Height`

``` purescript
class Height lang where
  height :: Number -> lang -> lang
```

#### Sizing
We can set the height of a UI.

#### `Padding`

``` purescript
class Padding lang where
  padding :: Number -> lang -> lang
```

We can pad inside a UI.

#### `Margin`

``` purescript
class Margin lang where
  margin :: Number -> lang -> lang
```

We can create space outside a UI.

#### `Size`

``` purescript
class Size lang where
  size :: Number -> Number -> lang -> lang
```

We can set both the width and the height of a UI.

#### `Width`

``` purescript
class Width lang where
  width :: Number -> lang -> lang
```

We can set the width of a UI.

#### `Title`

``` purescript
class Title lang where
  title :: String -> lang -> lang
```

## Miscellaneous
We can set the title of a UI.

#### `sizeFromWHLang`

``` purescript
instance sizeFromWHLang :: (Width lang, Height lang) => Size lang
```

Derived instances

#### `button'`

``` purescript
button' :: forall a e lang. (Show a, Button lang e) => a -> e -> lang
```

Helpers

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


#### `showRGB`

``` purescript
instance showRGB :: Show RGB
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
  = HTML Style Head Body
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


#### `Pixel`

``` purescript
newtype Pixel
  = Pixel Number
```


#### `Style`

``` purescript
newtype Style
  = Style StyleRec
```


#### `StyleRec`

``` purescript
type StyleRec = { width :: Maybe Pixel, height :: Maybe Pixel, backgroundColor :: Maybe RGB, color :: Maybe RGB }
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


#### `heightBody`

``` purescript
instance heightBody :: UI.Height Body
```


#### `heightBodyTag`

``` purescript
instance heightBodyTag :: UI.Height BodyTag
```


#### `heightHTML`

``` purescript
instance heightHTML :: UI.Height HTML
```


#### `heightListItem`

``` purescript
instance heightListItem :: UI.Height ListItem
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


#### `widthBody`

``` purescript
instance widthBody :: UI.Width Body
```


#### `widthBodyTag`

``` purescript
instance widthBodyTag :: UI.Width BodyTag
```


#### `widthHTML`

``` purescript
instance widthHTML :: UI.Width HTML
```


#### `widthListItem`

``` purescript
instance widthListItem :: UI.Width ListItem
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


#### `renderPixel`

``` purescript
instance renderPixel :: Render Pixel
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


#### `heightComponent`

``` purescript
instance heightComponent :: Height R.Component
```


#### `imageComponent`

``` purescript
instance imageComponent :: Image R.Component
```


#### `marginComponent`

``` purescript
instance marginComponent :: Margin R.Component
```


#### `paddingComponent`

``` purescript
instance paddingComponent :: Padding R.Component
```


#### `positionComponent`

``` purescript
instance positionComponent :: Position R.Component
```


#### `textComponent`

``` purescript
instance textComponent :: Text R.Component
```


#### `widthComponent`

``` purescript
instance widthComponent :: Width R.Component
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



## Module Graphics.UI.Interpreter.Wish

#### `Hierarchy`

``` purescript
type Hierarchy = [String]
```


#### `Names`

``` purescript
type Names = [String]
```


#### `Side`

``` purescript
data Side
  = T 
  | L 
  | R 
  | B 
```


#### `Wish`

``` purescript
data Wish
  = GM GeometryManager
  | Frame Hierarchy [Wish] Options
  | Label Hierarchy String Options
```


#### `GeometryManager`

``` purescript
data GeometryManager
  = Pack [Wish] Side
```


#### `Options`

``` purescript
newtype Options
  = Options OptionsRec
```


#### `OptionsRec`

``` purescript
type OptionsRec = { foreground :: Maybe RGB, background :: Maybe RGB }
```


#### `noOptions`

``` purescript
noOptions :: Options
```


#### `WishEnv`

``` purescript
type WishEnv = RWST Wish String Number
```


#### `backgroundColorNameWish`

``` purescript
instance backgroundColorNameWish :: BackgroundColorName Wish
```


#### `backgroundColorNameGeometryManager`

``` purescript
instance backgroundColorNameGeometryManager :: BackgroundColorName GeometryManager
```


#### `colorNameWish`

``` purescript
instance colorNameWish :: ColorName Wish
```


#### `colorNameGeometryManager`

``` purescript
instance colorNameGeometryManager :: ColorName GeometryManager
```


#### `groupHorizontalWish`

``` purescript
instance groupHorizontalWish :: GroupHorizontal Wish
```


#### `groupVerticalWish`

``` purescript
instance groupVerticalWish :: GroupVertical Wish
```


#### `textWish`

``` purescript
instance textWish :: Text Wish
```


#### `fixHierarchy`

``` purescript
fixHierarchy :: String -> [Wish] -> [Wish]
```


#### `fixSide`

``` purescript
fixSide :: Side -> [Wish] -> [Wish]
```


#### `printWish`

``` purescript
printWish :: Wish -> Eff (trace :: Trace | _) Unit
```


#### `renderOptions`

``` purescript
renderOptions :: Options -> String
```


#### `renderPack`

``` purescript
renderPack :: forall m. (Monad m) => Names -> Side -> WishEnv m _
```


#### `renderShebang`

``` purescript
renderShebang :: String
```


#### `renderSide`

``` purescript
renderSide :: Side -> String
```


#### `renderText`

``` purescript
renderText :: String -> String
```


#### `renderWish`

``` purescript
renderWish :: forall m. (Monad m) => WishEnv m Names
```

Generate a simple shell script.

#### `renderWish'`

``` purescript
renderWish' :: forall m. (Monad m) => WishEnv m Names
```


#### `rgb2HexStr`

``` purescript
rgb2HexStr :: RGB -> String
```


#### `modifies`

``` purescript
modifies :: forall m w. (Monad m, Monoid w) => _ -> RWST _ w _ m _
```

RWS stuff

#### `tellLn`

``` purescript
tellLn :: forall m w. (Monad m, Monoid w) => _ -> RWST _ w _ m Unit
```


#### `_Options`

``` purescript
_Options :: LensP Options OptionsRec
```

Optic stuff

#### `background`

``` purescript
background :: forall a b. Lens { background :: a | _ } { background :: b | _ } a b
```


#### `foreground`

``` purescript
foreground :: forall a b. Lens { foreground :: a | _ } { foreground :: b | _ } a b
```


#### `hierarchy`

``` purescript
hierarchy :: forall a b. Lens { hierarchy :: a | _ } { hierarchy :: b | _ } a b
```


#### `ws`

``` purescript
ws :: forall a b. Lens { ws :: a | _ } { ws :: b | _ } a b
```


#### `_Frame`

``` purescript
_Frame :: PrismP Wish { options :: Options, wishes :: [Wish], hierarchy :: Hierarchy }
```


#### `_GM`

``` purescript
_GM :: PrismP Wish GeometryManager
```


#### `_Label`

``` purescript
_Label :: PrismP Wish { options :: Options, label :: String, hierarchy :: Hierarchy }
```


#### `_Pack`

``` purescript
_Pack :: PrismP GeometryManager { side :: Side, wishes :: [Wish] }
```



## Module Graphics.UI.Interpreter.Wish.Foreign

#### `toHex`

``` purescript
toHex :: Number -> String
```




