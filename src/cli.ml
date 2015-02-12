open Automaton
open Coverules
open Coverules.Parser.Menhir


let _ =

  let args = Sys.argv |> Array.to_list |> List.tl in
  let automaton = automaton (Lexing.from_channel stdin) in
  let traces = List.map
                 (fun x -> trace (Lexing.from_channel (open_in x)))
                 args in
  let visited = visited traces automaton |> List.flatten in
  Printf.printf "%d/%d automaton transitions visited.\n"
                (List.length (List.filter (fun x -> x) visited))
                (List.length visited)
