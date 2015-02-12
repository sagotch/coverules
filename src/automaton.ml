type action =
  | Shift of string
  | Reduce of string
  | Accept of string

(** STATE: ID * RULES * POSSIBLE ACTIONS *)
type state = string * (string * action) list

type automaton = state list
