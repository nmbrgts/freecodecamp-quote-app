module Main exposing (..)

import Html exposing (Html, program, i)
import Html.Attributes as Attr
import Http
import Json.Decode as Decode exposing (Decoder)
import Element exposing (..)
import Element.Attributes exposing (..)
import Element.Events exposing (..)
import StyleSheet exposing (Class(..), stylesheet)


main : Program Never Model Msg
main =
    program
        { init = init
        , update = update
        , view = view
        , subscriptions = (\_ -> Sub.none)
        }



-- INIT


type Model
    = Loading
    | Available
        { quoteText : String
        , quoteAuth : String
        , tweetUrl : String
        }


init : ( Model, Cmd Msg )
init =
    Loading ! [ Http.send HandleQuote requestQuote ]



-- UPDATE


type Msg
    = RequestQuote
    | HandleQuote (Result Http.Error Quote)


type alias Quote =
    { quoteText : String
    , quoteAuth : String
    }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        RequestQuote ->
            model ! [ Http.send HandleQuote requestQuote ]

        HandleQuote (Ok { quoteText, quoteAuth }) ->
            Available
                { quoteText = quoteText
                , quoteAuth = quoteAuth
                , tweetUrl = makeTweetUrl quoteText quoteAuth
                }
                ! []

        HandleQuote (Err _) ->
            model ! []


makeTweetUrl : String -> String -> String
makeTweetUrl quote auth =
    "https://twitter.com/intent/tweet?"
        ++ "hashtags=quotes"
        ++ "&"
        ++ "related=freecodecamp"
        ++ "&"
        ++ "text="
        ++ Http.encodeUri ("\"" ++ quote ++ "\" " ++ auth)



-- REQUEST


url : String
url =
    "https://talaikis.com/api/quotes/random/"


requestQuote : Http.Request Quote
requestQuote =
    Http.get
        url
        qouteDecoder


qouteDecoder : Decoder Quote
qouteDecoder =
    liftd Quote
        |> apply (Decode.field "quote" Decode.string)
        |> apply (Decode.field "author" Decode.string)


liftd : a -> Decoder a
liftd =
    Decode.succeed


apply : Decoder b -> Decoder (b -> a) -> Decoder a
apply decoder res =
    Decode.andThen (\a -> Decode.map a decoder) res



-- VIEW


view : Model -> Html Msg
view model =
    let
        content =
            case model of
                Loading ->
                    el LoadingScreen [] <| text "..."

                Available model ->
                    column QuoteBox
                        [ maxWidth (percent 75)
                        , center
                        , verticalCenter
                        , padding 20
                        , spacing 10
                        ]
                        [ quoteBox model.quoteText
                        , authorLine model.quoteAuth
                        , row None
                            [ width (percent 100), alignRight, spacing 30 ]
                            [ tweetLink model.tweetUrl
                            , nextQuoteButton
                            ]
                        ]
    in
        viewport stylesheet <|
            row Background
                [ center
                , verticalCenter
                , height (percent 100)
                , width (percent 100)
                ]
                [ content ]


quoteBox : String -> Element Class variation Msg
quoteBox quote =
    paragraph QuoteText
        [ padding 10 ]
        [ el QuoteQuote [] (text "\"")
        , text quote
        ]


authorLine : String -> Element Class variation Msg
authorLine =
    el None [ alignRight ] << text


nextQuoteButton : Element Class variation Msg
nextQuoteButton =
    button Button
        [ width (px 35)
        , height (px 35)
        , center
        , verticalCenter
        , padding 5
        , onClick RequestQuote
        ]
        (html <| Html.i [ Attr.class "fa fa-arrow-right" ] [])


tweetLink : String -> Element Class variation Msg
tweetLink url =
    link url <|
        button Button
            [ width (px 35)
            , height (px 35)
            , center
            , verticalCenter
            , padding 5
            ]
            (html <| Html.i [ Attr.class "fa fa-twitter" ] [])
