# Module Documentation

## Module Graphics.UI

#### `Text`

``` purescript
class Text lang where
  text :: String -> lang
```

We can make some text.

#### `ColorName`

``` purescript
class ColorName lang where
  color :: Name -> lang -> lang
```

We can color the representation.

#### `List`

``` purescript
class List lang where
  list :: [lang] -> lang
```

A simple list of things.


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
  = P Style String
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
type StyleRec = { color :: Maybe RGB }
```


#### `noStyle`

``` purescript
noStyle :: Style
```


#### `printHTML`

``` purescript
printHTML :: forall eff. HTML -> Eff (trace :: Trace | eff) Unit
```


#### `_P`

``` purescript
_P :: forall a. Prism BodyTag BodyTag (Tuple Style String) a
```


#### `_Ul`

``` purescript
_Ul :: forall a. Prism BodyTag BodyTag (Tuple Style [ListItem]) a
```


#### `_Style`

``` purescript
_Style :: LensP Style StyleRec
```


#### `color`

``` purescript
color :: forall a b. LensP { color :: a | _ } a
```


#### `totallyBodyTag`

``` purescript
instance totallyBodyTag :: Totally BodyTag
```


#### `undefined`

``` purescript
undefined :: forall a. a
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

#### `textThermiteHtml`

``` purescript
instance textThermiteHtml :: Text (T.Html action)
```


#### `textThermiteComponentClass`

``` purescript
instance textThermiteComponentClass :: Text (T.ComponentClass props eff)
```




