module Fluent.Inline.I18n exposing (I18n, Language(..), attributes, attributesTitle, attributesWithVarAndTerm, compileTimeDatesAndNumbers, dateTimeFun, displayGender, dynamicTermKey, init, languageFromString, languageToString, languages, load, matchOnGender, matchOnNumbers, nestedTermKey, numberFun, staticTermKey)

{-| This file was generated by elm-i18n version 2.4.0.


-}

import Intl
import Json.Encode
import Maybe
import String
import Time


{-| Initialize an i18n instance based on a language and access to the Intl API


-}
init : Intl.Intl -> Language -> I18n
init intl lang =
    case lang of
        De ->
            ( de, intl )

        En ->
            ( en, intl )

        Fr ->
            ( fr, intl )


{-| Switch to another i18n instance based on a language


-}
load : Language -> I18n -> I18n
load lang ( _, intl ) =
    init intl lang


type alias I18n =
    ( I18n_, Intl.Intl )


type alias I18n_ =
    { attributes_ : String
    , attributesTitle_ : String
    , attributesWithVarAndTerm_ : String -> String
    , compileTimeDatesAndNumbers_ : String
    , dateTimeFun_ : Intl.Intl -> Time.Posix -> String
    , displayGender_ : String -> String
    , dynamicTermKey_ : String -> String
    , matchOnGender_ : String -> String
    , matchOnNumbers_ : Intl.Intl -> Float -> String
    , nestedTermKey_ : String
    , numberFun_ : Intl.Intl -> Float -> String
    , staticTermKey_ : String
    }


attributes : I18n -> String
attributes ( i18n, intl ) =
    i18n.attributes_


attributesTitle : I18n -> String
attributesTitle ( i18n, intl ) =
    i18n.attributesTitle_


attributesWithVarAndTerm : I18n -> String -> String
attributesWithVarAndTerm ( i18n, intl ) =
    i18n.attributesWithVarAndTerm_


compileTimeDatesAndNumbers : I18n -> String
compileTimeDatesAndNumbers ( i18n, intl ) =
    i18n.compileTimeDatesAndNumbers_


dateTimeFun : I18n -> Time.Posix -> String
dateTimeFun ( i18n, intl ) =
    i18n.dateTimeFun_ intl


displayGender : I18n -> String -> String
displayGender ( i18n, intl ) =
    i18n.displayGender_


dynamicTermKey : I18n -> String -> String
dynamicTermKey ( i18n, intl ) =
    i18n.dynamicTermKey_


matchOnGender : I18n -> String -> String
matchOnGender ( i18n, intl ) =
    i18n.matchOnGender_


matchOnNumbers : I18n -> Float -> String
matchOnNumbers ( i18n, intl ) =
    i18n.matchOnNumbers_ intl


nestedTermKey : I18n -> String
nestedTermKey ( i18n, intl ) =
    i18n.nestedTermKey_


numberFun : I18n -> Float -> String
numberFun ( i18n, intl ) =
    i18n.numberFun_ intl


staticTermKey : I18n -> String
staticTermKey ( i18n, intl ) =
    i18n.staticTermKey_


{-| `I18n` instance containing all values for the language En


-}
en : I18n_
en =
    { attributes_ = "Example 4: Attributes are supported"
    , attributesTitle_ = "Attributes"
    , attributesWithVarAndTerm_ = \var_ -> var_ ++ " static term"
    , compileTimeDatesAndNumbers_ =
        "Example 7: DATETIME und NUMBER functions with known values are evaluated at compile time:\n1/18/2022\n1/1/1970\n500,000"
    , dateTimeFun_ =
        \intl date_ ->
            "Example 5: DATETIME function is supported: "
                ++ Intl.formatDateTime
                    intl
                    { time = date_
                    , language = "en"
                    , args = [ ( "timeStyle", Json.Encode.string "long" ), ( "dateStyle", Json.Encode.string "full" ) ]
                    }
    , displayGender_ =
        \gender_ ->
            (case gender_ of
                "female" ->
                    "Female"

                "male" ->
                    "Male"

                _ ->
                    gender_
            )
                ++ "  "
    , dynamicTermKey_ = \adjective_ -> "Example 2: dynamic, " ++ adjective_ ++ " terms are supported."
    , matchOnGender_ =
        \gender_ ->
            case gender_ of
                "male" ->
                    "He wants his break now"

                _ ->
                    "She wants her break now"
    , matchOnNumbers_ =
        \intl amount_ ->
            (case
                Intl.formatFloat intl { number = amount_, language = "en", args = [] }
                    |> String.toFloat
                    |> Maybe.map
                        (\n -> Intl.determinePluralRuleFloat intl { language = "en", number = n, type_ = Intl.Cardinal }
                        )
                    |> Maybe.withDefault Intl.Other
                    |> Intl.pluralRuleToString
             of
                "one" ->
                    "I drank a single beer"

                _ ->
                    "I drank " ++ String.fromFloat amount_ ++ " beers"
            )
                ++ "\n "
    , nestedTermKey_ = "Example 3: nested terms are supported as long as there is no circular dependency."
    , numberFun_ =
        \intl num_ ->
            "Example 6: NUMBER function is supported: "
                ++ Intl.formatFloat
                    intl
                    { number = num_, language = "en", args = [ ( "style", Json.Encode.string "percent" ) ] }
    , staticTermKey_ = "Example 1: static terms are supported."
    }


{-| `I18n` instance containing all values for the language De


-}
de : I18n_
de =
    { attributes_ = "Beispiel 4: Attribute sind unterstützt"
    , attributesTitle_ = "Attribute"
    , attributesWithVarAndTerm_ = \var_ -> var_ ++ " Statische Terme"
    , compileTimeDatesAndNumbers_ =
        "Beispiel 7: DATETIME und NUMBER Funktion mit bekanntem Werten werden zur Compilezeit ausgewertet:\n18.1.2022\n1.1.1970\n500.000"
    , dateTimeFun_ =
        \intl date_ ->
            "Beispiel 5: DATETIME Funktion wird unterstützt: "
                ++ Intl.formatDateTime
                    intl
                    { time = date_, language = "de", args = [ ( "dateStyle", Json.Encode.string "full" ) ] }
    , displayGender_ =
        \gender_ ->
            (case gender_ of
                "female" ->
                    "Weiblich"

                "male" ->
                    "Männlich"

                _ ->
                    gender_
            )
                ++ "  "
    , dynamicTermKey_ = \adjective_ -> "Beispiel 2: Dynamische, " ++ adjective_ ++ " Terme sind unterstützt."
    , matchOnGender_ =
        \gender_ ->
            case gender_ of
                "male" ->
                    "Er will jetzt seine Pause"

                _ ->
                    "Sie will jetzt ihre Pause"
    , matchOnNumbers_ = \intl amount_ -> "Ich trank " ++ String.fromFloat amount_ ++ " Bier"
    , nestedTermKey_ = "Beispiel 3: Verschachtelte Terme sind unterstützt solange es keine zirkuläre Abhängigkeit gibt."
    , numberFun_ =
        \intl num_ ->
            "Beispiel 6: NUMBER Funktion wird unterstützt: "
                ++ Intl.formatFloat
                    intl
                    { number = num_, language = "de", args = [ ( "style", Json.Encode.string "percent" ) ] }
    , staticTermKey_ = "Beispiel 1: Statische Terme sind unterstützt."
    }


{-| `I18n` instance containing all values for the language Fr


-}
fr : I18n_
fr =
    { attributes_ = "Exemple 4 : Les attributs sont pris en charge"
    , attributesTitle_ = "Attribute"
    , attributesWithVarAndTerm_ = \var_ -> var_ ++ " termes statiques"
    , compileTimeDatesAndNumbers_ =
        "Exemple 7 : les fonctions DATETIME et NUMBER avec des valeurs connues sont évaluées au moment de la compilation:\n18/01/2022\n01/01/1970\n500 000"
    , dateTimeFun_ =
        \intl date_ ->
            "Exemple 5 : DATETIME fonction est prise en charge: "
                ++ Intl.formatDateTime intl { time = date_, language = "fr", args = [] }
    , displayGender_ =
        \gender_ ->
            case gender_ of
                "female" ->
                    "Femme"

                "male" ->
                    "Homme"

                _ ->
                    gender_
    , dynamicTermKey_ = \adjective_ -> "\"Exemple 2 : termes " ++ adjective_ ++ " dynamique sont pris en charge."
    , matchOnGender_ =
        \gender_ ->
            case gender_ of
                "male" ->
                    "Il veut sa pause maintenant"

                _ ->
                    "Elle veut sa pause maintenant"
    , matchOnNumbers_ =
        \intl amount_ ->
            (case
                Intl.formatFloat intl { number = amount_, language = "fr", args = [] }
                    |> String.toFloat
                    |> Maybe.map
                        (\n -> Intl.determinePluralRuleFloat intl { language = "fr", number = n, type_ = Intl.Cardinal }
                        )
                    |> Maybe.withDefault Intl.Other
                    |> Intl.pluralRuleToString
             of
                "one" ->
                    "j'ai bu une bière"

                _ ->
                    "J'ai bu " ++ String.fromFloat amount_ ++ " bières"
            )
                ++ "\n "
    , nestedTermKey_ = "Exemple 3 : termes imbriqués sont pris en charge tant qu'il n'y a pas de dépendance circulaire."
    , numberFun_ =
        \intl num_ ->
            "Exemple 6 : NUMBER fonction est prise en charge: "
                ++ Intl.formatFloat
                    intl
                    { number = num_, language = "fr", args = [ ( "style", Json.Encode.string "percent" ) ] }
    , staticTermKey_ = "Exemple 1 : termes statiques sont pris en charge."
    }


{-| Enumeration of the supported languages


-}
type Language
    = De
    | En
    | Fr


{-| A list containing all `Language`s


-}
languages : List Language
languages =
    [ De, En, Fr ]


{-| Convert a `Language` to its `String` representation.


-}
languageToString : Language -> String
languageToString lang_ =
    case lang_ of
        De ->
            "de"

        En ->
            "en"

        Fr ->
            "fr"


{-| Maybe parse a `Language` from a `String`. 
This only considers the keys given during compile time, if you need something like 'en-US' to map to the correct `Language`,
you should write your own parsing function.


-}
languageFromString : String -> Maybe Language
languageFromString lang_ =
    case lang_ of
        "de" ->
            Just De

        "en" ->
            Just En

        "fr" ->
            Just Fr

        _ ->
            Nothing
