type trace = (string * string) list

type env = {  st : string list ; (* States trace *)
             cur : string      ; (* Current token / rule *)
             env : trace       } (* (state * switch) seen *)
