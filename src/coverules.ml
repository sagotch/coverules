open Automaton
open Trace

module Parser = struct

    module Menhir = struct

        let automaton
            : Lexing.lexbuf -> automaton
          = MenhirAutomaton.automaton []

        let trace
            : Lexing.lexbuf -> trace
          = MenhirTrace.trace { Trace.st = []; cur = "" ; env = [] }

      end

  end

let visited
    : trace list -> automaton -> bool list list
  = fun traces automaton ->
  let traces = List.flatten traces in
  List.map
    (fun (st, ts) -> List.map (fun (t, _) -> List.mem (st, t) traces) ts)
    automaton
