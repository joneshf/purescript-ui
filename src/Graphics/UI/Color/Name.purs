module Graphics.UI.Color.Name where

  import Data.Profunctor (dimap)
  import Data.Profunctor.Choice (Choice)

  -- | The possible colors we can make.
  -- | Based on the first six stages of color in language by Berlin and Kay.
  data Name = Black
            | White
            | Red
            | Green
            | Yellow
            | Blue
            | Purple

  type PrismP s a = forall f p. (Applicative f, Choice p) => p a (f a) -> p s (f s)

  _Black :: PrismP Name Unit
  _Black = dimap (const unit) ((const Black) <$>)

  _White :: PrismP Name Unit
  _White = dimap (const unit) ((const White) <$>)

  _Red :: PrismP Name Unit
  _Red = dimap (const unit) ((const Red) <$>)

  _Green :: PrismP Name Unit
  _Green = dimap (const unit) ((const Green) <$>)

  _Yellow :: PrismP Name Unit
  _Yellow = dimap (const unit) ((const Yellow) <$>)

  _Blue :: PrismP Name Unit
  _Blue = dimap (const unit) ((const Blue) <$>)

  _Purple :: PrismP Name Unit
  _Purple = dimap (const unit) ((const Purple) <$>)
