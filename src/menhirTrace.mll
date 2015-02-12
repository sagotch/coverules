{
open Trace
}

let alpha = ['A'-'Z''a'-'z']
let num = ['0'-'9']
let alphanum_ = alpha | num | ['_']

(* At the beginning, token will be "" *)
rule trace env = parse

| eof
  { List.sort_uniq compare env.env }

| "State " (num+ as n) ":\n"
  { trace { env with st = n :: env.st } lexbuf }

| "Lookahead token is now " (alphanum_+ as t) " (" num + "-" num+ ")\n"
  { trace { env with cur = t } lexbuf }

| "Shifting (" (alphanum_+ as t) ") to state " num+ "\n"
  { trace { env with env = (List.hd env.st, t) :: env.env ;
                     cur = "" } lexbuf }

| "Accepting" (** Fake shifting of # *)
  { trace { env with env = (List.hd env.st, "#") :: env.env ;
                     cur = "" } lexbuf }

| "Reducing production " (alphanum_+ as r) [^'\n']+ "\n"
  { trace { st = List.tl env.st ;
            cur = "" ;
            env = (List.hd env.st, env.cur)
                  :: (List.hd (List.tl env.st), r)
                  :: env.env } lexbuf }

| _
  { trace env lexbuf }
