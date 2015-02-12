{
  open Automaton
}

let lower = ['a'-'z']
let upper = ['A'-'Z']
let alpha = lower | upper
let num = ['0'-'9']
let alphanum_ = alpha | num | ['_']

let token = upper alphanum_*
let prod = lower alphanum_* "'"?

let switch = token | prod | "#"

rule automaton acc = parse

  | eof
    { List.rev acc }

  | "State " (num+ as n) ":\n"
    { ignore (state_rules lexbuf) ;
      let a = state_actions [] lexbuf in
      automaton ((n, a) :: acc) lexbuf }

  | _
    { automaton acc lexbuf }

(* State rules are not keeped, just skipped. *)
and state_rules = parse

  | lower [^'\n']+ '\n'
    { state_rules lexbuf }

  | ""
    { "" }

and state_actions acc = parse

  | "-- On " (switch as s) " shift to state " (num+ as n) "\n"
    { state_actions ((s, Shift n) :: acc) lexbuf }

  | "-- On " (switch as s) " reduce production " (prod as p) [^'\n']+ "\n"
    { state_actions ((s, Reduce p) :: acc) lexbuf }

  | "-- On " (switch as s) " accept " (prod as p) "\n"
    { state_actions ((s, Accept p) :: acc) lexbuf }

  | ""
    { acc }

{
}
