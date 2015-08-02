import Html
import Html.Lazy exposing (lazy2)
import Html.Events as Html
import Html.Attributes as Html
import Html.Shorthand exposing (..)
import Bootstrap.Html exposing (..)
import Html exposing (blockquote)
import Html exposing (Html, text, toElement, fromElement)
import Signal exposing (Address)

--
-- Model
--

type Action =
            NavSignIn
            | NavPage1
            | NavPage2

type alias Model = {
    page : String
}

initialModel : Model
initialModel = { page = "page1" }

--
-- Plumbing
--

actions : Signal.Mailbox Action
actions =
    Signal.mailbox NavPage1

update : Action -> Model -> Model
update act model = case act of
    NavSignIn -> { model | page <- "signin" }
    NavPage1  -> { model | page <- "page1" }
    NavPage2  -> { model | page <- "page2" }


model : Signal Model
model = Signal.foldp update initialModel actions.signal


main : Signal Html
main = Signal.map (view actions.address) model

--
-- View
--

getInner : Address Action -> Model -> Html
getInner addr model =
        case model.page of
            "signin" -> lazy2 signin addr model
            "page1"  -> lazy2 page1 addr model
            "page2"  -> lazy2 page2 addr model

view : Address Action -> Model -> Html
view addr model =
    containerFluid_
        [ lazy2 navb addr model
        , getInner addr model ]


page1 : Address Action -> Model -> Html
page1 addr model = text "page one"


page2 : Address Action -> Model -> Html
page2 addr model = text "page two"


signin : Address Action -> Model -> Html
signin addr model = text "sign up"

navb : Address Action -> Model -> Html
navb addr model =
    navbar' "navbar navbar-inverted navbar-static-top"
        [ navbarHeader_ [ text "Elm Bootstrap Skeleton" ]
        , ul' { class = "nav navbar-nav" }
            [ a' { class = "active", href="#" } [ text "Page 1" ]
            , a' { class = "", href="#" } [ text "Page 2" ]
            , a' { class = "", href="#" } [ text "Sign In" ]
            ]
        ]
