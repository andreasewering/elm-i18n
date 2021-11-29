module I18n exposing (I18n, Language(..), decoder, greeting, init, languageFromString, languageSwitchInfo, languageToString, languages, load, order, static)

{-| This file was generated by elm-i18n version 1.2.0.


-}

import Array
import Http
import Json.Decode
import List
import String
import Tuple


type I18n
    = I18n (Array.Array String)


{-| Initialize an (empty) `I18n` instance. This is useful on startup when no JSON was `load`ed yet.


-}
init : I18n
init =
    I18n Array.empty


{-| Enumeration of the supported languages


-}
type Language
    = En
    | De


{-| A list containing all `Language`s


-}
languages : List Language
languages =
    [ En, De ]


{-| Convert a `Language` to its `String` representation.


-}
languageToString : Language -> String
languageToString lang_ =
    case lang_ of
        En ->
            "en"

        De ->
            "de"


{-| Maybe parse a `Language` from a `String`. 
This only considers the keys given during compile time, if you need something like 'en-US' to map to the correct `Language`,
you should write your own parsing function.


-}
languageFromString : String -> Maybe Language
languageFromString lang_ =
    case lang_ of
        "en" ->
            Just En

        "de" ->
            Just De

        _ ->
            Nothing


fallbackValue_ : String
fallbackValue_ =
    "..."


{-| Decode an `I18n` from Json. Make sure this is *only* used on the files generated by this package.


-}
decoder : Json.Decode.Decoder I18n
decoder =
    Json.Decode.array Json.Decode.string |> Json.Decode.map I18n


{-| 
Load translations for a `Language` from the server. This is a simple `Http.get`, if you need more customization,
you can use the `decoder` instead. Pass the path and a callback to your `update` function, for example

    load { language = En, path = "/i18n", onLoad = GotTranslations }

will make a `GET` request to /i18n/messages.en.json and will call GotTranslations with the decoded response.


-}
load : { language : Language, path : String, onLoad : Result Http.Error I18n -> msg } -> Cmd msg
load opts_ =
    Http.get
        { expect = Http.expectJson opts_.onLoad decoder
        , url = opts_.path ++ "/messages." ++ languageToString opts_.language ++ ".json"
        }


{-| Replaces all placeholder expressions in a string in order with the given values


-}
replacePlaceholders : List String -> String -> String
replacePlaceholders list_ str_ =
    List.foldl
        (\val_ ( i_, acc_ ) -> ( i_ + 1, String.replace ("{{" ++ String.fromInt i_ ++ "}}") val_ acc_ ))
        ( 0, str_ )
        list_
        |> Tuple.second


greeting : I18n -> String -> String
greeting (I18n i18n_) name_ =
    case Array.get 0 i18n_ of
        Just translation_ ->
            replacePlaceholders [ name_ ] translation_

        Nothing ->
            fallbackValue_


languageSwitchInfo : I18n -> String -> String
languageSwitchInfo (I18n i18n_) currentLanguage_ =
    case Array.get 1 i18n_ of
        Just translation_ ->
            replacePlaceholders [ currentLanguage_ ] translation_

        Nothing ->
            fallbackValue_


order : I18n -> { a | language : String, name : String } -> String
order (I18n i18n_) placeholders_ =
    case Array.get 2 i18n_ of
        Just translation_ ->
            replacePlaceholders [ placeholders_.language, placeholders_.name ] translation_

        Nothing ->
            fallbackValue_


static : I18n -> String
static (I18n i18n_) =
    case Array.get 3 i18n_ of
        Just translation_ ->
            translation_

        Nothing ->
            fallbackValue_
