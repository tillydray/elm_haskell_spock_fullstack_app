module Update exposing (update)

import Api
import Model
import Msg
import Task
import Time


update : Msg.Msg -> Model.Model -> ( Model.Model, Cmd Msg.Msg )
update msg model =
    case msg of
        Msg.NoOp ->
            ( model, Cmd.none )

        Msg.FetchPatients result ->
            case result of
                Ok pts ->
                    ( { model | patients = pts }, Cmd.none )

                Err _ ->
                    -- Could add better error output here.
                    ( model, Cmd.none )

        Msg.PutPatient result ->
            -- do something with the result?
            ( model, Cmd.none )

        Msg.DropdownMsg state ->
            ( { model | dropdownState = state }, Cmd.none )

        Msg.SelectedPatient pt ->
            ( { model | selectedPatient = Just pt }, Cmd.none )

        Msg.PatientNote note ->
            ( { model
                | selectedPatient =
                    Maybe.map (\p -> { p | patientNote = note }) model.selectedPatient
              }
            , Cmd.none
            )

        Msg.SubmitForm pt ->
            ( model, Api.putPatient pt )

        Msg.Tick seconds ->
            let
                task =
                    if model.timerState == Model.Running then
                        Task.perform Msg.IncrementTimer Time.now

                    else
                        Cmd.none
            in
            ( { model | secondsElapsed = seconds }, task )

        Msg.StartTimer ->
            ( { model | timerState = Model.Running }, Cmd.none )

        Msg.StopTimer ->
            ( { model | timerState = Model.Stopped }, Cmd.none )

        Msg.IncrementTimer _ ->
            let
                ptSeconds =
                    Time.posixToMillis model.resultTime + 1
            in
            ( { model
                | resultTime = Time.millisToPosix ptSeconds
                , selectedPatient =
                    Maybe.map (\pt -> { pt | patientSeconds = ptSeconds }) model.selectedPatient
              }
            , Cmd.none
            )
