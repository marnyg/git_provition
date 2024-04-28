open Core

let explode_string s = List.init (String.length s) ~f:(String.get s)
let rec stringRep n s = if n = 0 then "" else s ^ stringRep (n - 1) s

let map_to_nums line =
  let replacements =
    [ "one", "1"
    ; "two", "2"
    ; "three", "3"
    ; "four", "4"
    ; "five", "5"
    ; "six", "6"
    ; "seven", "7"
    ; "eight", "8"
    ; "nine", "9"
    ]
  in
  let rec replace_first str from =
    if from >= String.length str
    then str
    else (
      match
        List.find_map replacements ~f:(fun (pattern, with_) ->
          if String.is_prefix
               ~prefix:pattern
               (String.sub str ~pos:from ~len:(min (String.length pattern) (String.length str - from)))
          then Some (pattern, with_)
          else None)
      with
      | Some (pattern, with_) ->
        let before = String.sub str ~pos:0 ~len:from in
        let after =
          String.sub str ~pos:(from + String.length pattern) ~len:(String.length str - from - String.length pattern)
        in
        before ^ with_ ^ replace_first after 0
      | None -> replace_first str (from + 1))
  in
  replace_first line 0
;;

let ( $ ) f x = f x

let%expect_test "map_to_nums" =
  print_string $ map_to_nums "one2three4";
  [%expect {| 1234 |}]
;;

let%expect_test "map_to_nums" =
  print_endline $ map_to_nums "one2three4";
  print_endline $ map_to_nums "one2nine";
  [%expect {|
    1234
    129 |}]
;;

let%expect_test "map_string_list_to_nums" =
  let a =
    [ "two1nine"; "eightwothree"; "abcone2threexyz"; "xtwone3four"; "4nineeightseven2"; "zoneight234"; "7pqrstsixteen" ]
  in
  List.iter a ~f:(fun x -> print_endline $ map_to_nums x);
  [%expect {|
    219
    8wo3
    abc123xyz
    x2ne34
    49872
    z1ight234
    7pqrst6teen |}]
;;

let%expect_test "map_to_nums" =
  print_endline $ map_to_nums "eightqrssm9httwogqshfxninepnfrppfzhsc";
  print_endline $ map_to_nums "one111jxlmc7tvklrmhdpsix";
  print_endline $ map_to_nums "bptwone4sixzzppg";
  print_endline $ map_to_nums "ninezfzseveneight5kjrjvtfjqt5nineone ";
  print_endline $ map_to_nums "58kk";
  print_endline $ map_to_nums "5b32";
  print_endline $ map_to_nums "1dtwo";
  print_endline $ map_to_nums "six7two7sixtwo78";
  print_endline $ map_to_nums "mvhsixpptztjh13sixthree2";
  print_endline $ map_to_nums "six1bqqvrxndt";
  print_endline $ map_to_nums "fourmk5grmqone944nbvtj";
  [%expect
    {|
    8qrssm9ht2gqshfx9pnfrppfzhsc
    1111jxlmc7tvklrmhdp6
    bp2ne46zzppg
    9zfz785kjrjvtfjqt591
    58kk
    5b32
    1d2
    67276278
    mvh6pptztjh13632
    61bqqvrxndt
    4mk5grmq1944nbvtj |}]
;;

let find_first_and_last_number_in_line line =
  let numbers =
    line
    |> explode_string
    |> List.filter_map ~f:(fun s ->
      match s with
      | '0' .. '9' -> Int.of_string (String.of_char s) |> Option.some
      | _ -> None)
  in
  List.hd_exn numbers, List.last_exn numbers
;;

let find_first_and_last_number_in_line_part2 line =
  let numbers =
    line
    |> map_to_nums
    |> explode_string
    |> List.filter_map ~f:(fun s ->
      match s with
      | '0' .. '9' -> Int.of_string (String.of_char s) |> Option.some
      | _ -> None)
  in
  List.hd_exn numbers, List.last_exn numbers
;;

let a =
  [ "two1nine"; "eightwothree"; "abcone2threexyz"; "xtwone3four"; "4nineeightseven2"; "zoneight234"; "7pqrstsixteen" ]
;;

let%expect_test "map_to_nums" =
  List.iter a ~f:(fun x ->
    let first, last = find_first_and_last_number_in_line_part2 x in
    Fmt.pr "\n->%d%d" first last);
  [%expect {|
    ->29
    ->83
    ->13
    ->24
    ->42
    ->14
    ->76 |}]
;;

let%expect_test "map_to_nums" =
  let b =
    [ "one2three4"
    ; "one111jxlmc7tvklrmhdpsix"
    ; "bptwone4sixzzppg"
    ; "ninezfzseveneight5kjrjvtfjqt5nineone"
    ; "58kk"
    ; "5b32"
    ; "1dtwo"
    ; "six7two7sixtwo78"
    ; "mvhsixpptztjh13sixthree2"
    ; "six1bqqvrxndt"
    ; "fourmk5grmqone944nbvtj"
    ]
  in
  List.iter b ~f:(fun x ->
    let first, last = find_first_and_last_number_in_line_part2 x in
    Fmt.pr "\n%d%d <- %s" first last x);
  [%expect
    {|
    14 <- one2three4
    16 <- one111jxlmc7tvklrmhdpsix
    26 <- bptwone4sixzzppg
    91 <- ninezfzseveneight5kjrjvtfjqt5nineone
    58 <- 58kk
    52 <- 5b32
    12 <- 1dtwo
    68 <- six7two7sixtwo78
    62 <- mvhsixpptztjh13sixthree2
    61 <- six1bqqvrxndt
    44 <- fourmk5grmqone944nbvtj 
    |}]
;;
