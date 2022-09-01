module Api.ApiRequest exposing (..)

import Coordinates exposing (..)
import Http
import Json.Decode as Decode exposing (Decoder)
import Msg exposing (..)
import Stations exposing (..)



-- Stations Request


loadStations : String -> String -> String -> String -> String -> Cmd Msg
loadStations lat lng rad sort gasType =
    Http.get
        { url = "https://creativecommons.tankerkoenig.de/json/list.php?lat=" ++ lat ++ "&lng=" ++ lng ++ "&rad=" ++ rad ++ "&sort=" ++ sort ++ "&type=" ++ gasType ++ "&apikey=62a37924-593d-a9ef-a198-4c45ec74b6f4"
        , expect = Http.expectJson GotStations stationsParser
        }


stationParser : Decoder Station
stationParser =
    Decode.map8 Station
        (Decode.field "brand" Decode.string)
        (Decode.field "dist" Decode.float)
        (Decode.field "price" (Decode.maybe Decode.float))
        (Decode.field "isOpen" Decode.bool)
        (Decode.field "street" Decode.string)
        (Decode.field "houseNumber" Decode.string)
        (Decode.field "postCode" Decode.int)
        (Decode.field "place" Decode.string)


stationsParser : Decoder (List Station)
stationsParser =
    Decode.field "stations" (Decode.list stationParser)



-- Coordinates Request


loadCoords : String -> Cmd Msg
loadCoords searchParameter =
    Http.get
        { url = "https://api.myptv.com/geocoding/v1/locations/by-text?searchText=" ++ searchParameter ++ "&apiKey=ZWU2NzVhZWU4MmM1NGRhNmJmMDMzM2U5OTQzNjFkZDg6M2U1NDMxOTMtYmY4ZC00NzkxLTgyY2QtNjcyOTAyODIwOWZl"
        , expect = Http.expectJson GotCoords coordinatesParser
        }


coordParser : Decoder Coordinate
coordParser =
    Decode.field "referencePosition"
        (Decode.map2 Coordinate
            (Decode.field "latitude" Decode.float)
            (Decode.field "longitude" Decode.float)
        )


coordinatesParser : Decoder (List Coordinate)
coordinatesParser =
    Decode.field "locations" (Decode.list coordParser)
