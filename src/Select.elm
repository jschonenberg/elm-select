module Select exposing (State, state, setIsOpen, setSelectedOption, Config, Option, select)

import Dropdown as DD
import Html exposing (Html, button, div, text)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)


type alias State a msg =
    { isOpen : DD.State
    , selectedOption : Maybe (Option a msg)
    }


state : State a msg
state =
    { isOpen = False
    , selectedOption = Nothing
    }


setIsOpen : Bool -> State a msg -> State a msg
setIsOpen isOpen state =
    { state | isOpen = isOpen }


setSelectedOption : Maybe (Option a msg) -> State a msg -> State a msg
setSelectedOption option state =
    { state | selectedOption = option }


type alias Option a msg =
    { value : a
    , label : Html msg
    }


type alias Config a msg =
    { identifier : String
    , defaultLabel : Html msg
    , toggleMsg : Bool -> msg
    , optionSelectedMsg : Option a msg -> msg
    }


select : State a msg -> Config a msg -> List (Option a msg) -> Html msg
select state config options =
    DD.dropdown state.isOpen
        (dropdownConfig config)
        (viewToggle state config)
        (DD.drawer div
            [ class "elm-select--drawer-wrapper" ]
            [ div [ class "elm-select--drawer-body" ] (viewOptions config options) ]
        )


viewToggle : State a msg -> Config a msg -> DD.State -> DD.Config msg -> Html msg
viewToggle state config =
    let
        label =
            case state.selectedOption of
                Just option ->
                    option.label

                Nothing ->
                    config.defaultLabel
    in
        DD.toggle button [ class "elm-select--toggle" ] [ label ]


viewOptions : Config a msg -> List (Option a msg) -> List (Html msg)
viewOptions config options =
    let
        viewOption o =
            button
                [ onClick (config.optionSelectedMsg o) ]
                [ o.label ]
    in
        List.map viewOption options


dropdownConfig : Config a msg -> DD.Config msg
dropdownConfig selectConfig =
    DD.Config
        selectConfig.identifier
        DD.OnClick
        (class "visible")
        selectConfig.toggleMsg
