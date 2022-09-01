module Msg exposing (..)

import Bootstrap.Accordion as Accordion
import Bootstrap.Dropdown as Dropdown
import Coordinates exposing (..)
import Http
import Stations exposing (..)


type Msg
    = Noop
    | GotStations (Result Http.Error Stations)
    | GetCoords
    | GotCoords (Result Http.Error Coordinates)
    | UpdateTextInput String
    | DropdownFuel Dropdown.State
    | DropdownSort Dropdown.State
    | DropdownRadius Dropdown.State
    | SetGasType String
    | SetSortType String
    | SetRadiusType String
    | CheckBoxChecked Bool
    | GoToMaps String
    | AccordionState Accordion.State
