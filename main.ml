
open Core
open Async

(* Run the async scheduler and exit *)
let () =
  let%bind () = Async.Scheduler.run () in
  exit 0


(* Print hello world message *)
let () =
  print_endline "Hello, World!"

let () =
  let%bind () = Async.Scheduler.run () in
  print_endline "Hello, World!" 

