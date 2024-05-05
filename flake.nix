{
  description = "My OCaml project";

  inputs.nixpkgs.url = "nixpkgs/nixos-unstable";
  inputs.opam-nix.url = "github:tweag/opam-nix";
  inputs.mynvim.url = "github:marnyg/nixos";
  inputs.nixvim.url = "github:nix-community/nixvim";

  outputs = { self, nixvim, mynvim, nixpkgs, opam-nix }:
    let
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
      myPro = (opam-nix.lib.x86_64-linux.buildDuneProject { } "myPro" ./. { ocaml-base-compiler = "*"; }).myPro;

      mynixvim =
        nixvim.legacyPackages.x86_64-linux.makeNixvimWithModule
          {
            inherit pkgs; module = {
            imports = [ mynvim.nixvimModules.nixVim ];
          };
          };

      myShell = pkgs.mkShell {
        buildInputs = with pkgs; [ nixd dune_3 ocaml opam ocamlPackages.ocamlformat_0_26_0 ];
        packages = [ mynixvim ];
      };
    in
    {
      packages.x86_64-linux.default = myPro;
      apps.x86_64-linux.default = { type = "app"; program = "${myPro}/bin/day02"; };
      checks.x86_64-linux.tests = pkgs.stdenv.mkDerivation {
        name = "dune-test";
        buildInputs = [ myPro ];
        src = ./.;
        checkPhase = "dune test && touch $out/ok ";
        installPhase = "echo No installation needed for test && mkdir -p $out && touch $out/testOK";
      };

      formatter.x86_64-linux = pkgs.nixpkgs-fmt;
      devShells.x86_64-linux.default = myShell;
    };
}

