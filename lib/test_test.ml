let%test "name" = true
(* let%test "name" = false *)

(* true means ok, false or exn means broken *)
(* let%test "nam2e" = false(* true means ok, false or exn means broken *) *)
let echo a = Fmt.pr "Hello, World! %d" a
