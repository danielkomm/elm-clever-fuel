module Main exposing (..)

import Api.ApiRequest
import Bootstrap.Accordion as Accordion exposing (onlyOneOpen)
import Bootstrap.Badge as Badge
import Bootstrap.Button as Button
import Bootstrap.Card as Card
import Bootstrap.Card.Block as Block
import Bootstrap.Dropdown as Dropdown
import Bootstrap.Form.Checkbox as Checkbox
import Bootstrap.Form.Input as Input
import Bootstrap.Form.InputGroup as InputGroup
import Bootstrap.Table as Table
import Bootstrap.Utilities.Spacing as Spacing
import Browser
import Browser.Navigation as Navigation
import Coordinates exposing (..)
import Html exposing (Html, br, button, div, h1, input, text)
import Html.Attributes as Attrs exposing (..)
import Html.Events exposing (onClick)
import Msg exposing (..)
import Stations exposing (..)
import Style.Style


init : () -> ( Model, Cmd Msg )
init _ =
    ( Model Ready Ready "" Dropdown.initialState Dropdown.initialState Dropdown.initialState "price" "5" "e5" False "" (Accordion.initialStateCardOpen "")
    , Cmd.none
    )


type LoadingState a
    = Ready
    | Loading
    | Success a
    | Failed



-- Model params: Loading Stations, Loading Coordinates, InputFieldSearch, FuelTypeDropDown, SortDropDown, RadiusDropDown, Sorting, Radius, GasType, Checkbox, GoToGMaps, AddressAccordion


type Model
    = Model (LoadingState Stations) (LoadingState Coordinates) String Dropdown.State Dropdown.State Dropdown.State String String String Bool String Accordion.State



-- DRAW FUNCTIONS


drawTable : Model -> Html Msg
drawTable model =
    case model of
        Model Ready Ready _ _ _ _ _ _ _ _ _ _ ->
            div [] [ Badge.badgeWarning Style.Style.userInformationsAboutState [ text "APPLICATION IS READY TO USE" ] ]

        Model Loading _ _ _ _ _ _ _ _ _ _ _ ->
            div [] [ Badge.badgeWarning Style.Style.userInformationsAboutState [ text "LOADING STATIONS ..." ] ]

        Model _ Loading _ _ _ _ _ _ _ _ _ _ ->
            div [] [ Badge.badgeWarning Style.Style.userInformationsAboutState [ text "LOADING LOCATION ... " ] ]

        Model (Success response) initCoordinates searchParameter dropDownStateFuel dropDownStateSort dropDownStateRadius sort radius gasType isChecked goToMaps accordionState ->
            case response of
                [] ->
                    Badge.badgeDanger Style.Style.userInformationsAboutState [ text "NO DATA FOUND" ]

                responseList ->
                    Table.table
                        { options = [ Table.striped, Table.hover ]
                        , thead =
                            Table.simpleThead
                                [ Table.th [] [ text "Name" ]
                                , Table.th [] [ text "Distance" ]
                                , Table.th [] [ text "Price" ]
                                , Table.th [] [ text "Open" ]
                                , Table.th [] [ text "Navigate" ]
                                ]
                        , tbody =
                            Table.tbody []
                                (List.indexedMap
                                    (\index station ->
                                        Table.tr []
                                            [ Table.td [] [ drawAccordion index (Model Loading initCoordinates searchParameter dropDownStateFuel dropDownStateSort dropDownStateRadius sort radius gasType isChecked goToMaps accordionState) station.brand station.street station.houseNumber station.postCode station.place ]
                                            , Table.td [] [ text (String.fromFloat station.dist ++ " km") ]
                                            , Table.td []
                                                [ text
                                                    (case station.price of
                                                        Just price ->
                                                            String.fromFloat price ++ "€"

                                                        Nothing ->
                                                            "N/A"
                                                    )
                                                ]
                                            , Table.td []
                                                [ text
                                                    (if station.isOpen then
                                                        "✅"

                                                     else
                                                        "❌"
                                                    )
                                                ]
                                            , Table.td [] [ button [ onClick (GoToMaps ("https://www.google.de/maps/place/" ++ station.street ++ "+" ++ station.houseNumber ++ ", " ++ "+" ++ String.fromInt station.postCode ++ "+" ++ station.place)), style "border" "none", style "background-color" "transparent", style "cursor" "pointer" ] [ text "🧭" ] ]
                                            ]
                                    )
                                    responseList
                                )
                        }

        Model _ (Success response) _ _ _ _ _ _ _ _ _ _ ->
            div [] [ Badge.badgeWarning Style.Style.userInformationsAboutState [ text "PLEASE CHOOSE A FUEL TYPE" ] ]

        Model Failed _ _ _ _ _ _ _ _ _ _ _ ->
            div [] [ Badge.badgeDanger Style.Style.userInformationsAboutState [ text "FAILED TO LOAD STATIONS!" ] ]

        Model _ Failed _ _ _ _ _ _ _ _ _ _ ->
            div [] [ Badge.badgeDanger Style.Style.userInformationsAboutState [ text "FAILED TO LOAD COORDINATES!" ] ]


drawHomePageHtml : Html Msg
drawHomePageHtml =
    div [ style "text-align" "center" ]
        [ h1 [] [ Badge.pillSuccess [ style "margin-top" "20px" ] [ text "CLEVER-FUEL" ] ]
        , input Style.Style.inputStyle []
        , Button.button [ Button.success, Button.onClick GetCoords, Button.attrs Style.Style.searchButton, Button.large ] [ text "Search" ]
        , div Style.Style.homePageContainer
            [ Badge.pillSuccess Style.Style.headerBadge [ text "WELCOME TO CLEVER-FUEL" ]
            , div [] [ Badge.pillPrimary Style.Style.homePageContainerSmallHeadingBadge [ text "WHAT IS CLEVER-FUEL?" ] ]
            , div Style.Style.homePageContainerText [ text "With Clever fuel you can display the best, cheapest and nearest gas stations in your area. Look for gas stations in your area or throughout Germany and refuel at fair prices!" ]
            , div [] [ Badge.pillPrimary Style.Style.homePageContainerSmallHeadingBadge [ text "HOW TO USE CLEVER-FUEL?" ] ]
            , div Style.Style.homePageContainerText [ text "Use the search field to find certain places near you or in Germany and confirm your search with the search button.", br [] [], text "Choose your fuel type to display all gas stations within a radius of 5km.", br [] [], text "Use our filter options to see different fuel types, to obtain the radius or to change the sorting from price to distance or to only see the open gas stations nearby.", br [] [], text "You can use the compass to open the gas station informations at Google Maps and use it for a direct routing.", br [] [], text "By clicking on the name of the gas station you can open the address informations." ]
            ]
        ]


drawSelectGasTypes : Dropdown.State -> String -> Html Msg
drawSelectGasTypes dropDownState value =
    Dropdown.dropdown
        dropDownState
        { options = []
        , toggleMsg = DropdownFuel
        , toggleButton =
            Dropdown.toggle [ Button.success ]
                [ text
                    ("Fuel type: "
                        ++ (case value of
                                "e5" ->
                                    "Super E5"

                                "e10" ->
                                    "Super E10"

                                "diesel" ->
                                    "Diesel"

                                s ->
                                    s
                           )
                    )
                ]
        , items =
            [ Dropdown.buttonItem [ onClick (SetGasType "e5") ] [ text "Super E5" ]
            , Dropdown.buttonItem [ onClick (SetGasType "e10") ] [ text "Super E10" ]
            , Dropdown.buttonItem [ onClick (SetGasType "diesel") ] [ text "Diesel" ]
            ]
        }


drawSelectSortType : Dropdown.State -> String -> Html Msg
drawSelectSortType dropDownState value =
    Dropdown.dropdown
        dropDownState
        { options = [ Dropdown.attrs [ Spacing.m2 ] ]
        , toggleMsg = DropdownSort
        , toggleButton =
            Dropdown.toggle [ Button.success ]
                [ text
                    ("Sort: "
                        ++ (case value of
                                "price" ->
                                    "Price"

                                "dist" ->
                                    "Distance"

                                s ->
                                    s
                           )
                    )
                ]
        , items =
            [ Dropdown.buttonItem [ onClick (SetSortType "price") ] [ text "Price" ]
            , Dropdown.buttonItem [ onClick (SetSortType "dist") ] [ text "Distance" ]
            ]
        }


drawSelectRadius : Dropdown.State -> String -> Html Msg
drawSelectRadius dropDownState value =
    Dropdown.dropdown
        dropDownState
        { options = []
        , toggleMsg = DropdownRadius
        , toggleButton =
            Dropdown.toggle [ Button.success ]
                [ text
                    ("Radius: " ++ value ++ "km")
                ]
        , items =
            [ Dropdown.buttonItem [ onClick (SetRadiusType "1") ] [ text "1km" ]
            , Dropdown.buttonItem [ onClick (SetRadiusType "10") ] [ text "5km" ]
            , Dropdown.buttonItem [ onClick (SetRadiusType "10") ] [ text "10km" ]
            , Dropdown.buttonItem [ onClick (SetRadiusType "15") ] [ text "15km" ]
            , Dropdown.buttonItem [ onClick (SetRadiusType "20") ] [ text "20km" ]
            , Dropdown.buttonItem [ onClick (SetRadiusType "25") ] [ text "25km" ]
            ]
        }


drawFilterCheckbox : Bool -> Html Msg
drawFilterCheckbox isChecked =
    div [] [ Checkbox.checkbox [ Checkbox.id "checkbox", Checkbox.onCheck CheckBoxChecked, Checkbox.checked isChecked ] "Show only open" ]


drawAccordion : Int -> Model -> String -> String -> String -> Int -> String -> Html Msg
drawAccordion index (Model initStations initCoordinates searchParameter dropDownStateFuel dropDownStateSort dropDownStateRadius sort radius gasType isChecked goToMaps accordionState) stationName stationStreet stationHouseNumber stationPostCode stationPlace =
    Accordion.config AccordionState
        |> Accordion.withAnimation
        |> Accordion.onlyOneOpen
        |> Accordion.cards
            [ Accordion.card
                { id = String.fromInt index
                , options = [ Card.attrs Style.Style.accordionHeaderDefaultStyle ]
                , header =
                    Accordion.header Style.Style.accordionHeaderDefaultStyle <|
                        Accordion.toggle Style.Style.accordionHeadingStyle
                            [ text
                                (if stationName == "" then
                                    "N/A"

                                 else
                                    stationName
                                )
                            ]
                , blocks =
                    [ Accordion.block []
                        [ Block.text Style.Style.gasStationAddressStyle [ text stationStreet, text " ", text stationHouseNumber, text ", ", text (String.fromInt stationPostCode), text " ", text stationPlace ] ]
                    ]
                }
            ]
        |> Accordion.view accordionState



-- HELPER FUNCTIONS


sendRequestHelper : Model -> ( Model, Cmd Msg )
sendRequestHelper (Model initStations initCoordinates searchParameter dropDownStateFuel dropDownStateSort dropDownStateRadius sort radius gasType isChecked goToMaps accordionState) =
    case initCoordinates of
        Ready ->
            ( Model initStations initCoordinates searchParameter dropDownStateFuel dropDownStateSort dropDownStateRadius sort radius gasType isChecked goToMaps accordionState, Cmd.none )

        Loading ->
            ( Model initStations initCoordinates searchParameter dropDownStateFuel dropDownStateSort dropDownStateRadius sort radius gasType isChecked goToMaps accordionState, Cmd.none )

        Success list ->
            case list of
                [] ->
                    ( Model initStations initCoordinates searchParameter dropDownStateFuel dropDownStateSort dropDownStateRadius sort radius gasType isChecked goToMaps accordionState, Cmd.none )

                initCoords :: _ ->
                    ( Model Loading initCoordinates searchParameter dropDownStateFuel dropDownStateSort dropDownStateRadius sort radius gasType isChecked goToMaps accordionState, Api.ApiRequest.loadStations (String.fromFloat initCoords.latitude) (String.fromFloat initCoords.longitude) radius sort gasType )

        Failed ->
            ( Model initStations initCoordinates searchParameter dropDownStateFuel dropDownStateSort dropDownStateRadius sort radius gasType isChecked goToMaps accordionState, Cmd.none )



-- UPDATE, VIEW, SUBSCRIPTIONS, MAIN


update : Msg -> Model -> ( Model, Cmd Msg )
update msg (Model initStations initCoordinates searchParameter dropDownStateFuel dropDownStateSort dropDownStateRadius sort radius gasType isChecked goToMaps accordionState) =
    case msg of
        Noop ->
            ( Model initStations initCoordinates searchParameter dropDownStateFuel dropDownStateSort dropDownStateRadius sort radius gasType isChecked goToMaps accordionState, Cmd.none )

        GotStations result ->
            case result of
                Err error ->
                    ( Model Failed initCoordinates searchParameter dropDownStateFuel dropDownStateSort dropDownStateRadius sort radius gasType isChecked goToMaps accordionState, Cmd.none )

                Ok stations ->
                    ( Model
                        (Success
                            (List.filter
                                (\station ->
                                    if isChecked then
                                        station.isOpen

                                    else
                                        True
                                )
                                stations
                            )
                        )
                        initCoordinates
                        searchParameter
                        dropDownStateFuel
                        dropDownStateSort
                        dropDownStateRadius
                        sort
                        radius
                        gasType
                        isChecked
                        goToMaps
                        accordionState
                    , Cmd.none
                    )

        GetCoords ->
            ( Model initStations Loading searchParameter dropDownStateFuel dropDownStateSort dropDownStateRadius sort radius gasType isChecked goToMaps accordionState, Api.ApiRequest.loadCoords searchParameter )

        GotCoords result ->
            case result of
                Err error ->
                    ( Model initStations Failed searchParameter dropDownStateFuel dropDownStateSort dropDownStateRadius sort radius gasType isChecked goToMaps accordionState, Cmd.none )

                Ok coordinates ->
                    ( Model initStations (Success coordinates) searchParameter dropDownStateFuel dropDownStateSort dropDownStateRadius sort radius gasType isChecked goToMaps accordionState, Cmd.none )

        UpdateTextInput inputParam ->
            ( Model initStations initCoordinates inputParam dropDownStateFuel dropDownStateSort dropDownStateRadius sort radius gasType isChecked goToMaps accordionState, Cmd.none )

        DropdownFuel state ->
            ( Model initStations initCoordinates searchParameter state dropDownStateSort dropDownStateRadius sort radius gasType isChecked goToMaps accordionState, Cmd.none )

        DropdownSort state ->
            ( Model initStations initCoordinates searchParameter dropDownStateFuel state dropDownStateRadius sort radius gasType isChecked goToMaps accordionState, Cmd.none )

        DropdownRadius state ->
            ( Model initStations initCoordinates searchParameter dropDownStateFuel dropDownStateSort state sort radius gasType isChecked goToMaps accordionState, Cmd.none )

        SetGasType newFuelType ->
            sendRequestHelper (Model initStations initCoordinates searchParameter dropDownStateFuel dropDownStateSort dropDownStateRadius sort radius newFuelType isChecked goToMaps accordionState)

        SetSortType newSort ->
            sendRequestHelper (Model initStations initCoordinates searchParameter dropDownStateFuel dropDownStateSort dropDownStateRadius newSort radius gasType isChecked goToMaps accordionState)

        SetRadiusType newRadius ->
            sendRequestHelper (Model initStations initCoordinates searchParameter dropDownStateFuel dropDownStateSort dropDownStateRadius sort newRadius gasType isChecked goToMaps accordionState)

        CheckBoxChecked isCheckedState ->
            sendRequestHelper (Model initStations initCoordinates searchParameter dropDownStateFuel dropDownStateSort dropDownStateRadius sort radius gasType isCheckedState goToMaps accordionState)

        GoToMaps url ->
            ( Model initStations initCoordinates searchParameter dropDownStateFuel dropDownStateSort dropDownStateRadius sort radius gasType isChecked goToMaps accordionState, Navigation.load url )

        AccordionState state ->
            ( Model initStations initCoordinates searchParameter dropDownStateFuel dropDownStateSort dropDownStateRadius sort radius gasType isChecked goToMaps state, Cmd.none )


view : Model -> Html Msg
view (Model initStations initCoordinates searchParameter dropDownStateFuel dropDownStateSort dropDownStateRadius sort radius gasType isChecked goToMaps accordionState) =
    case initCoordinates of
        Ready ->
            drawHomePageHtml

        Loading ->
            drawHomePageHtml

        Success coords ->
            div Style.Style.centerNavigationBar [ drawSelectGasTypes dropDownStateFuel gasType, drawSelectSortType dropDownStateSort sort, drawSelectRadius dropDownStateRadius radius, drawFilterCheckbox isChecked, drawTable (Model initStations initCoordinates searchParameter dropDownStateFuel dropDownStateSort dropDownStateRadius sort radius gasType isChecked goToMaps accordionState) ]

        Failed ->
            drawHomePageHtml


subscriptions : Model -> Sub Msg
subscriptions (Model _ _ _ dropDownStateFuel dropDownStateSort dropDownStateRadius _ _ _ _ _ accordionState) =
    Sub.batch
        [ Dropdown.subscriptions dropDownStateFuel DropdownFuel
        , Dropdown.subscriptions dropDownStateSort DropdownSort
        , Dropdown.subscriptions dropDownStateRadius DropdownRadius
        , Accordion.subscriptions accordionState AccordionState
        ]


main : Program () Model Msg
main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
