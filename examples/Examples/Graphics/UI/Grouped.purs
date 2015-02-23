{- |  We now use groups to make some more interesting UI's.
-}
module Examples.Graphics.UI.Grouped where

  import Graphics.UI
  import Graphics.UI.Color.Name

  grouped :: forall g
          .  ( BackgroundColorName g, ColorName g, GroupVertical g
             , GroupHorizontal g, Text g
             )
          => g
  grouped = groupVertical [ groupHorizontal [ text "This is one row of stuff"
                                            , text "Here's another thing!"
                                            , text "It's all blue!"
                                            ]
                            # color Blue
                          , groupHorizontal [ text "We started a new row"
                                            , text "Here's some blue text"
                                              # color Blue
                                            , text "Here's some red text"
                                              # color Red
                                            , text "Here's some yellow text with a black background"
                                              # color Yellow
                                              # backgroundColor Black
                                            ]
                          ]
