# Module Documentation

## Module Graphics.UI


Here we specify the possible ways to build UI's. 

#### `Text`

``` purescript
class Text lang where
  text :: String -> lang
```

We can make some text.

#### `ColorStyle`

``` purescript
class ColorStyle lang where
  color :: Color -> lang -> lang
```

We can color the representation.

#### `Color`

``` purescript
data Color
  = Black 
  | White 
  | Red 
```

The possible colors we can make.


## Module Graphics.UI.String


#### `textString`

``` purescript
instance textString :: Text String
```


#### `stringify`

``` purescript
stringify :: String -> String
```

We interpret `String` fairly easily here. It's just identity.


## Module Graphics.UI.Terminal


`Terminal` implements `Text` and `ColorStyle`.

#### `Terminal`

``` purescript
newtype Terminal
  = Terminal String
```


#### `runTerminal`

``` purescript
runTerminal :: Terminal -> String
```


#### `textTerminal`

``` purescript
instance textTerminal :: Text Terminal
```


#### `colorStyleTerminal`

``` purescript
instance colorStyleTerminal :: ColorStyle Terminal
```

We use ANSI color codes.


## Module Graphics.UI.HTML


#### `HTML`

``` purescript
data HTML
  = HTML Head Body
```

We make an AST of `HTML`.

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
newtype Body
  = Body [BodyTag]
```


#### `BodyTag`

``` purescript
newtype BodyTag
  = P String
```


#### `textHTML`

``` purescript
instance textHTML :: Text HTML
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


#### `renderString`

``` purescript
instance renderString :: Render String
```

We can also render `String`s.

#### `renderArray`

``` purescript
instance renderArray :: (Render h) => Render [h]
```

We can render an array of things by `intercalat`ing a newline.



