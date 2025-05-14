{
  inputs = {
    opam-nix.url = "github:tweag/opam-nix";
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.follows = "opam-nix/nixpkgs";
  };
  outputs =
    {
      self,
      flake-utils,
      opam-nix,
      nixpkgs,
    }@inputs:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        lib = nixpkgs.lib;
        pkgs = nixpkgs.legacyPackages.${system};
        stdenv = pkgs.stdenv;
        on = opam-nix.lib.${system};
        src = builtins.path { path = ./.; name = "source"; };

        devPackagesQuery = {
          # You can add "development" packages here. They will get added to the devShell automatically.
          ocaml-lsp-server = "*";
          ocamlformat = "*";
        };
        query = devPackagesQuery // {
          ocaml-base-compiler = "5.3.0";
        };

        scope = on.buildDuneProject { } "firmata" src query;
        overlay = final: prev: {
          firmata = prev.firmata.overrideAttrs (oa: {
            nativeBuildInputs = oa.nativeBuildInputs
              ++ lib.optionals stdenv.isDarwin [ pkgs.apple-sdk_15 ];
            NIX_CFLAGS_COMPILE = lib.optionals stdenv.isDarwin [
              "-isysroot" "${pkgs.apple-sdk_15.sdkroot}"
            ];
          });
        };

        scope' = scope.overrideScope overlay;
        devPackages = builtins.attrValues (pkgs.lib.getAttrs (builtins.attrNames devPackagesQuery) scope');

      in
      {
        legacyPackages = scope.overrideScope overlay;
        packages.default = self.legacyPackages.${system}.firmata;
        devShells.default = pkgs.mkShell {
          buildInputs = devPackages
            ++ lib.optionals stdenv.isDarwin [ pkgs.apple-sdk_15 ];
          shellHook = if !stdenv.isDarwin then "" else ''
            export NIX_CFLAGS_COMPILE="-isysroot ${pkgs.apple-sdk_15.sdkroot} ''${NIX_CFLAGS_COMPILE}"
          '';
        };
      }
    );
}
