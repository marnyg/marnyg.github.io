
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


module DAG = struct
  type t = {
    nodes : (string * int) list;
    edges : (string * string) list;
  }
  let empty = { nodes = []; edges = [] }
  let add_node t node = { t with nodes = node :: t.nodes }
  let add_edge t edge = { t with edges = edge :: t.edges }
  let nodes t = t.nodes
  let edges t = t.edges

  let rec longest_path dag = 
    let nodes = nodes dag in
    let edges = edges dag in
    let rec longest_path_helper nodes edges = 
      match nodes with
      | [] -> 0
      | [node] -> 0
      | node :: nodes -> 
        let node_cost = List.assoc node nodes in
        let max_path = List.fold_left (fun max_path edge -> 
          let edge_cost = List.assoc edge edges in
          max max_path (edge_cost + longest_path_helper nodes edges)
        ) 0 edges in
        node_cost + max_path

  let print_dag dag = 
    let nodes = nodes dag in
    let edges = edges dag in
    print_endline "Nodes:";
    List.iter (fun (node, _) -> print_endline node) nodes;
    print_endline "Edges:";
    List.iter (fun (node1, node2) -> print_endline (node1 ^ " -> " ^ node2)) edges
end

let dag = DAG.empty
let dag = DAG.add_node dag "A"
let dag = DAG.add_node dag "B"
let dag = DAG.add_edge dag ("A", "B")
let dag = DAG.add_node dag "C"
let dag = DAG.add_edge dag ("B", "C")
let dag = DAG.add_node dag "D"
let dag = DAG.add_edge dag ("C", "D")