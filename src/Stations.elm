module Stations exposing (..)


type alias Stations =
    List Station


type alias Station =
    { brand : String
    , dist : Float
    , price : Maybe Float
    , isOpen : Bool
    , street : String
    , houseNumber : String
    , postCode : Int
    , place : String
    }
