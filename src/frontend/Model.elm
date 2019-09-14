-- TODO don't expose constructors


module Model exposing (..)

import Bootstrap.Dropdown as Dropdown


type Model
    = Failure
    | Loading Dropdown.State
    | Success (List Patient)



-- TODO improve type safety by making newtypes


type alias Patient =
    { patientId : Int
    , patientName : PatientName
    , patientNote : String
    , patientSeconds : Int
    }


type PatientName
    = PatientName String


patientNameToString : PatientName -> String
patientNameToString (PatientName s) =
    s
