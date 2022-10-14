port module Frontend exposing (app)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Lamdera
import Types exposing (..)


app =
    Lamdera.frontend
        { init =
            \_ _ -> init
        , onUrlRequest = \_ -> NothingChanged
        , onUrlChange = \_ -> NothingChanged
        , update = updateWithStorage
        , updateFromBackend = updateFromBackend
        , subscriptions = \_ -> load Load
        , view = view
        }


init =
    ( { text = ""
      , storedText = ""
      }
    , Cmd.none
    )



-- UPDATE


update msg model =
    case msg of
        TextChanged text ->
            ( { model | text = text }
            , Cmd.none
            )

        NothingChanged ->
            ( model
            , Cmd.none
            )

        Load text ->
            ( { model | storedText = text }
            , Cmd.none
            )


updateWithStorage msg oldModel =
    case msg of
        Load text ->
            update msg oldModel

        _ ->
            -- Every other action except load, will also persist and load the value
            let
                ( newModel, cmds ) =
                    update msg oldModel
            in
            ( newModel
            , Cmd.batch
                [ setStorage newModel.text
                , getStorage ()
                , cmds
                ]
            )


updateFromBackend msg model =
    ( model
    , Cmd.none
    )



-- VIEW


view model =
    { title = "Local storage"
    , body =
        [ div []
            [ input
                [ type_ "text"
                , placeholder "Text"
                , onInput TextChanged
                , value model.text
                ]
                []
            ]
        , div [] [ text <| "model.text:" ++ model.storedText ]
        , div [] [ text <| "model.storedText:" ++ model.storedText ]
        ]
    }



-- PORTS


port setStorage : String -> Cmd msg


port load : (String -> msg) -> Sub msg


port getStorage : () -> Cmd msg
