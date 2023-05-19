{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    rust-overlay.url = "github:oxalica/rust-overlay";
    rust-overlay.inputs.nixpkgs.follows = "nixpkgs";

    cargo2nix.url = "github:cargo2nix/cargo2nix";
    cargo2nix.inputs.nixpkgs.follows = "nixpkgs";
    cargo2nix.inputs.rust-overlay.follows = "rust-overlay";
    cargo2nix.inputs.flake-utils.follows = "rust-overlay/flake-utils";

    flake-utils.follows = "rust-overlay/flake-utils";
    flake-utils.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs: with inputs;
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [
            cargo2nix.overlays.default
            (import rust-overlay)
          ];
        };

        rustPkgs = pkgs.rustBuilder.makePackageSet {
          rustToolchain = pkgs.rust-bin.stable.latest.default;
          packageFun = import ./Cargo.nix;
        };

      in
      rec {
        packages = {
          member-a = (rustPkgs.workspace.member-a { });
          # member-with-seq = (rustPkgs.workspace.member-with-seq { });

          # creates a test binary in result
          member-a-test = (rustPkgs.workspace.member-a { compileMode = "test"; });

          default = packages.member-a;
        };

        devShells.default = (rustPkgs.workspaceShell {
          buildInputs = [
            cargo2nix.packages."${system}".cargo2nix
          ];
        });
      }
    );
}
