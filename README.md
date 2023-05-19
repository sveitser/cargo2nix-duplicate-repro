Having the same revision of a git dependency in the tree causes `cargo2nix` to
generate an invalid `Cargo.nix`.

```
$ cargo tree
member-a v0.1.0 (/home/lulu/r/sveitser/cargo2nix-duplicate-error/member-a)
└── rustversion v1.0.12 (proc-macro) (https://github.com/dtolnay/rustversion#a85f2db2)

member-b v0.1.0 (/home/lulu/r/sveitser/cargo2nix-duplicate-error/member-b)
└── rustversion v1.0.12 (proc-macro) (https://github.com/dtolnay/rustversion?tag=1.0.12#a85f2db2)
```

To reproduce run `nix build`

```
$ nix build
warning: Git tree '/home/lulu/r/sveitser/cargo2nix-duplicate-error' is dirty
trace: warning: rust-overlay's flake output `overlay` is deprecated in favor of `overlays.default` for Nix >= 2.7
error:
       … while evaluating the attribute 'member-a'

         at /nix/store/fnm8c3pzfg57hhd9f8gh57sw5v968zl7-source/flake.nix:36:11:

           35|         packages = {
           36|           member-a = (rustPkgs.workspace.member-a { });
             |           ^
           37|           # member-with-seq = (rustPkgs.workspace.member-with-seq { });

       … while calling a functor (an attribute set with a '__functor' attribute)

         at /nix/store/fnm8c3pzfg57hhd9f8gh57sw5v968zl7-source/flake.nix:28:20:

           27|
           28|         rustPkgs = pkgs.rustBuilder.makePackageSet {
             |                    ^
           29|           rustToolchain = pkgs.rust-bin.stable.latest.default;

       (stack trace truncated; use '--show-trace' to show the full trace)

       error: attribute '"git+https://github.com/dtolnay/rustversion".rustversion."1.0.12"' already defined at /nix/store/fnm8c3pzfg57hhd9f8gh57sw5v968zl7-source/Cargo.nix:64:3

       at /nix/store/fnm8c3pzfg57hhd9f8gh57sw5v968zl7-source/Cargo.nix:75:3:

           74|
           75|   "git+https://github.com/dtolnay/rustversion".rustversion."1.0.12" = overridableMkRustCrate (profileName: rec {
             |   ^
           76|     name = "rustversion";
```

