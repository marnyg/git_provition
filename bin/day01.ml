open Core
open MyPro


let _ = print_endline "\nPart1"
let _ = print_endline "----------"

let part1 =
  Utils.read_file "inputs/day01.txt"
  |> List.map ~f:Day01.find_first_and_last_number_in_line
  |> List.map ~f:(fun (a, b) -> string_of_int a ^ string_of_int b)
  |> List.fold ~init:0 ~f:(fun acc x -> acc + int_of_string x)
;;
let () = print_endline (string_of_int part1)

(* let%expect_test "map_to_nums" = *)
(* print_endline (string_of_int part1) *)
(*   [%expect {| *)
(*     54159 |}] *)
(* ;; *)


let _ = print_endline "----------"
let _ = print_endline "\nPart2"
let _ = print_endline "----------"

let part2 =
  Utils.read_file "inputs/day01.txt"
  |> List.map ~f:Day01.find_first_and_last_number_in_line_part2
  |> List.map ~f:(fun (a, b) -> string_of_int a ^ string_of_int b)
  |> List.fold_left ~f:(fun acc str -> acc + int_of_string str) ~init:0
;;
let () = print_endline (string_of_int part2)

let _ = print_endline "----------"
