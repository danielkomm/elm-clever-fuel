module Style.Style exposing (..)

import Bootstrap.Utilities.Spacing as Spacing
import Html exposing (Attribute)
import Html.Attributes as Attrs exposing (..)
import Html.Events exposing (onInput)
import Msg exposing (..)


centerNavigationBar : List (Attribute Msg)
centerNavigationBar =
    [ style "text-align" "center"
    , style "position" "-webkit-sticky"
    , style "position" "sticky"
    ]


inputStyle : List (Attribute Msg)
inputStyle =
    [ placeholder "Search location"
    , onInput UpdateTextInput
    , style "border-radius" "25px"
    , style "width" "75%"
    , style "padding" "15px"
    , style "border" "0"
    , style "box-shadow" "4px 4px 10px rgba(0,0,0,0.06)"
    , style "margin-top" "50px"
    ]


headerBadge : List (Attribute Msg)
headerBadge =
    [ Spacing.ml1
    , style "font-size" "12pt"
    , style "margin-bottom" "15px"
    , style "margin-top" "10px"
    ]


searchButton : List (Attribute Msg)
searchButton =
    [ Spacing.m2
    , style "border-radius" "25px"
    ]


gasStationAddressStyle : List (Attribute Msg)
gasStationAddressStyle =
    [ style "color" "grey"
    , style "font-size" "11pt"
    ]


homePageContainer : List (Attribute Msg)
homePageContainer =
    [ style "display" "block"
    , style "margin-left" "auto"
    , style "margin-right" "auto"
    , style "left" "50%"
    , style "top" "50%"
    , style "tranform" "translate(-50%, -50%"
    , style "height" "375px"
    , style "width" "600px"
    , style "background" "255 255 255"
    , style "overflow" "hidden"
    , style "border-radius" "20px"
    , style "box-shadow" "0 0 20px 8px #d0d0d0"
    , style "margin-top" "50px"
    ]


homePageContainerSmallHeadingBadge : List (Attribute Msg)
homePageContainerSmallHeadingBadge =
    [ style "font-size" "9pt"
    , style "margin-left" "-380px"
    ]


homePageContainerText : List (Attribute Msg)
homePageContainerText =
    [ style "text-align" "left"
    , style "font-size" "10pt"
    , style "margin-left" "16px"
    , style "margin-right" "16px"
    , style "margin-top" "10px"
    , style "margin-bottom" "40px"
    ]


userInformationsAboutState : List (Attribute Msg)
userInformationsAboutState =
    [ Spacing.ml1
    , style "font-size" "10pt"
    ]


accordionHeadingStyle : List (Attribute Msg)
accordionHeadingStyle =
    [ style "border" "none"
    , style "background-color" "transparent"
    , style "cursor" "pointer"
    , style "text-decoration" "none"
    , style "color" "black"
    , style "font-weight" "bold"
    ]


accordionHeaderDefaultStyle : List (Attribute Msg)
accordionHeaderDefaultStyle =
    [ style "padding" "0"
    , style "background-color" "transparent"
    , style "border" "0"
    , style "border-top-color" "transparent"
    , style "border-top-style" "none"
    , style "border-top-width" "0px"
    , style "border-right-color" "transparent"
    , style "border-right-style" "none"
    , style "border-right-width" "0px"
    , style "border-bottom-color" "transparent"
    , style "border-bottom-style" "none"
    , style "border-bottom-width" "0px"
    , style "border-left-color" "transparent"
    , style "border-left-style" "none"
    , style "border-left-width" "0px"
    , style "border-image-source" "unset"
    , style "border-image-slice" "unset"
    , style "border-image-width" "unset"
    , style "border-image-outset" "unset"
    , style "border-image-repeat" "unset"
    ]
