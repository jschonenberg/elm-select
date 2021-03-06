module Main exposing (..)

import Html exposing (Html, text)
import Select exposing (Option, select, setIsOpen, setSelectedOption)


main : Program Never Model Msg
main =
    Html.program
        { init = init ! []
        , update = update
        , view = view
        , subscriptions = (\_ -> Sub.none)
        }


init : Model
init =
    { select = Select.state }


type alias Model =
    { select : Select.State Country Msg }


type Country
    = BE
    | FR
    | DE
    | NL


type Msg
    = ToggleSelect Bool
    | CountrySelected (Option Country Msg)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ToggleSelect newState ->
            ( { model | select = model.select |> setIsOpen newState }, Cmd.none )

        CountrySelected option ->
            ( { model
                | select =
                    model.select
                        |> setIsOpen False
                        |> setSelectedOption (Just option)
              }
            , Cmd.none
            )


view : Model -> Html Msg
view model =
    select
        model.select
        selectConfig
        [ Option BE (text "Belgium")
        , Option FR (text "France")
        , Option DE (text "Germany")
        , Option NL (text "The Netherlands")
        ]


selectConfig : Select.Config Country Msg
selectConfig =
    (Select.Config
        "selectCountry"
        (text "Country ")
        ToggleSelect
        CountrySelected
    )
