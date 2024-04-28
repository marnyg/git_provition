(lang dune 3.7)

(name myPro)

(generate_opam_files true)

(source
 (github username/reponame))

(authors "Author Name")

(maintainers "Maintainer Name")

(license LICENSE)

(documentation https://url/to/documentation)

(package
 (name myPro)
 (synopsis "A short synopsis")
 (description "A longer description")
 (depends 
   tyxml
   ppx_inline_test
   core 
   base
   ; ocaml
   ocamlformat
   ; ocaml-lsp-server
   ; dune 
   (alcotest :with-test) 
   base-unix cmdliner fmt;fmt
   )
 (tags
  (topics "to describe" your project)))

; See the complete stanza docs at https://dune.readthedocs.io/en/stable/dune-files.html#dune-project
