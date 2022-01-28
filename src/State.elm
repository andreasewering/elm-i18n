module State exposing (..)

import Dict exposing (Dict)
import Dict.NonEmpty exposing (NonEmpty)
import List.NonEmpty
import Types.Features as Features exposing (Features)
import Types.InterpolationKind as InterpolationKind exposing (InterpolationKind)
import Types.Segment as Segment exposing (TKey, TValue)


type alias Identifier =
    String


type alias Language =
    String


type alias Translations =
    List ( TKey, TValue )


type alias Translation resources =
    { pairs : Translations
    , resources : resources
    }


type alias OptimizedJson =
    { filename : String
    , content : String
    }


type alias TranslationSet resources =
    NonEmpty Language (Translation resources)


type alias State resources =
    Dict Identifier (TranslationSet resources)


type alias NonEmptyState resources =
    NonEmpty Identifier (TranslationSet resources)


getLanguages : NonEmptyState resources -> List Language
getLanguages =
    Dict.NonEmpty.getFirstEntry
        >> Tuple.second
        >> Dict.NonEmpty.keys
        >> List.sort


collectiveTranslationSet : NonEmptyState () -> TranslationSet ()
collectiveTranslationSet =
    Dict.NonEmpty.toNonEmptyList
        >> List.NonEmpty.map Tuple.second
        >> List.NonEmpty.foldl1 combineTranslationSets


combineTranslationSets : TranslationSet () -> TranslationSet () -> TranslationSet ()
combineTranslationSets t =
    Dict.NonEmpty.toList
        >> List.foldl
            (\( lang, { pairs } ) acc ->
                let
                    merge val =
                        case val of
                            Just existing ->
                                { pairs = pairs ++ existing.pairs, resources = () }

                            Nothing ->
                                { pairs = pairs, resources = () }
                in
                Dict.NonEmpty.update lang merge acc
            )
            t


getAllResources : State resources -> List resources
getAllResources =
    Dict.values >> List.concatMap (Dict.NonEmpty.values >> List.map .resources)


interpolationMap : TranslationSet any -> Dict TKey (Dict String InterpolationKind)
interpolationMap =
    Dict.NonEmpty.map (\_ ts -> List.map (Tuple.mapSecond Segment.interpolationVars) ts.pairs |> Dict.fromList)
        >> Dict.NonEmpty.foldl1
            (mergeDictIntoDict <|
                \key s1 s2 -> Dict.insert key <| mergeInterpolationKinds s1 s2
            )


mergeInterpolationKinds : Dict String InterpolationKind -> Dict String InterpolationKind -> Dict String InterpolationKind
mergeInterpolationKinds =
    mergeDictIntoDict <|
        \key i1 i2 ->
            case i1 of
                InterpolationKind.Simple ->
                    Dict.insert key i2

                InterpolationKind.Typed _ ->
                    Dict.insert key i1


mergeDictIntoDict :
    (comparable -> v -> v -> Dict comparable v -> Dict comparable v)
    -> Dict comparable v
    -> Dict comparable v
    -> Dict comparable v
mergeDictIntoDict f d1 d2 =
    Dict.merge Dict.insert f Dict.insert d1 d2 Dict.empty


inferFeatures : NonEmptyState any -> Features
inferFeatures =
    Dict.NonEmpty.values >> Features.combineMap inferFeaturesTranslationSet


inferFeaturesTranslationSet : TranslationSet any -> Features
inferFeaturesTranslationSet =
    Dict.NonEmpty.values >> Features.combineMap (.pairs >> inferFeaturesTranslations)


inferFeaturesTranslations : Translations -> Features
inferFeaturesTranslations =
    Features.combineMap (Tuple.second >> Segment.inferFeatures)


isIntlNeededForKey : TKey -> NonEmptyState () -> Bool
isIntlNeededForKey key =
    collectiveTranslationSet
        >> interpolationMap
        >> Dict.get key
        >> Maybe.withDefault Dict.empty
        >> Dict.toList
        >> List.any (Tuple.second >> InterpolationKind.isIntlInterpolation)


allTranslationKeys : NonEmptyState () -> List TKey
allTranslationKeys =
    collectiveTranslationSet >> interpolationMap >> Dict.keys
