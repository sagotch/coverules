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

let switch = token | prod | "."

rule automaton acc = parse

  | eof
    { List.rev acc }

  | "state " (num+ as n) "\n"
    { ignore (state_rules lexbuf) ;
      let a = state_actions [] lexbuf in
      let a = state_gotos a lexbuf in
      automaton ((n, a) :: acc) lexbuf }

  | _
    { automaton acc lexbuf }

and state_rules = parse

  | '\t'  [^'\n']* '\n'
    { state_rules lexbuf }

  | "\n" { "" } (* Strip last empty line. *)

and state_actions acc = parse

  | '\t' (switch as s) "  shit " (num+ as n) '\n'
    { state_actions ((s, Shift n) :: acc) lexbuf }

  | '\t' (switch as s) "  reduce " (num+ as n) '\n'
    { state_actions ((s, Reduce n) :: acc) lexbuf }

  | '\t' switch "  error\n"
    { state_actions acc lexbuf }

  | "\n" { acc } (* Strip last empty line. *)

(* gotos are shift on production ("shift" is for tokens). *)
and state_gotos acc = parse

  | '\t' (switch as s) "  goto " (num+ as n) "\n"
    { state_gotos ((s, Shift n) :: acc) lexbuf }
