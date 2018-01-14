module StyleSheet exposing (Class(..), stylesheet)

import Style
import Style.Color as Color
import Style.Border as Border
import Style.Font as Font
import Color exposing (..)


type Class
    = None
    | Background
    | LoadingScreen
    | QuoteBox
    | QuoteQuote
    | QuoteText
    | Button


stylesheet : Style.StyleSheet Class variation
stylesheet =
    Style.styleSheet
        [ Style.style None []
        , Style.style Background
            [ Color.background darkGrey ]
        , Style.style LoadingScreen
            [ Color.text white
            , Font.size 100
            ]
        , Style.style QuoteBox
            [ Color.text white
            , Color.background darkGrey
            , Font.typeface [ Font.sansSerif ]
            , Font.size 25
            , Font.lineHeight 1.5
            ]
        , Style.style QuoteQuote
            [ Font.size 75
            , Font.typeface [ Font.fantasy ]
            , Font.bold
            , Font.lineHeight 0.5
            ]
        , Style.style QuoteText
            [ Border.bottom 2
            , Color.border white
            ]
        , Style.style Button
            [ Color.text white
            , Color.background lightCharcoal
            , Border.rounded 3
            ]
        ]
