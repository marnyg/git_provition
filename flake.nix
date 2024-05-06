{
  description = "My OCaml project";

  inputs.nixpkgs.url = "nixpkgs/nixos-unstable";
  inputs.opam-nix.url = "github:tweag/opam-nix";
  # inputs.mynvim.url = "github:marnyg/nixos";
  inputs.mynvim.url = "path:/home/mar/git/nixos";
  inputs.nixvim.url = "github:nix-community/nixvim";
  inputs.neorg-overlay.url = "github:nvim-neorg/nixpkgs-neorg-overlay";
  inputs.neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";


  outputs = { self, nixvim, mynvim, nixpkgs, opam-nix, ... }@inputs:
    let
      pkgs = import nixpkgs
        {
          system = "x86_64-linux";
          overlays = [
            inputs.neovim-nightly-overlay.overlays.default
            inputs.neorg-overlay.overlays.default
          ];
        };
      myPro = (opam-nix.lib.x86_64-linux.buildDuneProject { } "myPro" ./. {
        ocaml-base-compiler = "*";
      }).myPro;

      mynixvim =
        nixvim.legacyPackages.x86_64-linux.makeNixvimWithModule
          {
            inherit pkgs; module = {
            imports = [
              mynvim.nixvimModules.nixVim
              {
                langs.ocaml.enable = true;
                opts.makeprg = "dune build";
                plugins.dap.configurations.ocaml = [
                  {
                    name = "OCaml Debug test.bc";
                    type = "ocamlearlybird";
                    request = "launch";
                    program = ''''${workspaceFolder}/_build/default/bin/main.bc'';
                  }
                ];
              }
            ];
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
      devShells.x86_64-linux.marnyg = myShell;
    };
}

