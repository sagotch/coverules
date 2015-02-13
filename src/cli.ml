open Automaton
open Coverules
open Coverules.Parser.Menhir


let _ =

  let af = ref "" in (* automaton file *)
  let tf = ref [] in (* trace files *)

  let usage = "coverules --automaton FILE [FILES]" in

  let options =
    Arg.align [
        "--automaton", Arg.Set_string af,
        " Mark next file as the automaton to be used." ;
      ] in

  Arg.parse options (fun s -> tf := s :: !tf) usage ;

  let af = !af in
  let tf = !tf in

  let lex f = Lexing.from_channel (open_in f) in

  let automaton = automaton (lex af) in
  let traces = List.map (fun f -> trace (lex f)) tf in

  let visited = visited traces automaton |> List.flatten in
  Printf.printf "%d/%d automaton transitions visited.\n"
                (List.length (List.filter (fun x -> x) visited))
                (List.length visited)
