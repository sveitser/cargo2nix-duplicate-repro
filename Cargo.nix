# This file was @generated by cargo2nix 0.11.0.
# It is not intended to be manually edited.

args@{
  release ? true,
  rootFeatures ? [
    "member-a/default"
    "member-b/default"
  ],
  rustPackages,
  buildRustPackages,
  hostPlatform,
  hostPlatformCpu ? null,
  hostPlatformFeatures ? [],
  target ? null,
  codegenOpts ? null,
  profileOpts ? null,
  rustcLinkFlags ? null,
  rustcBuildFlags ? null,
  mkRustCrate,
  rustLib,
  lib,
  workspaceSrc,
}:
let
  workspaceSrc = if args.workspaceSrc == null then ./. else args.workspaceSrc;
in let
  inherit (rustLib) fetchCratesIo fetchCrateLocal fetchCrateGit fetchCrateAlternativeRegistry expandFeatures decideProfile genDrvsByProfile;
  profilesByName = {
  };
  rootFeatures' = expandFeatures rootFeatures;
  overridableMkRustCrate = f:
    let
      drvs = genDrvsByProfile profilesByName ({ profile, profileName }: mkRustCrate ({ inherit release profile hostPlatformCpu hostPlatformFeatures target profileOpts codegenOpts rustcLinkFlags rustcBuildFlags; } // (f profileName)));
    in { compileMode ? null, profileName ? decideProfile compileMode release }:
      let drv = drvs.${profileName}; in if compileMode == null then drv else drv.override { inherit compileMode; };
in
{
  cargo2nixVersion = "0.11.0";
  workspace = {
    member-a = rustPackages.unknown.member-a."0.1.0";
    member-b = rustPackages.unknown.member-b."0.1.0";
  };
  "unknown".member-a."0.1.0" = overridableMkRustCrate (profileName: rec {
    name = "member-a";
    version = "0.1.0";
    registry = "unknown";
    src = fetchCrateLocal (workspaceSrc + "/member-a");
    dependencies = {
      rustversion = buildRustPackages."git+https://github.com/dtolnay/rustversion".rustversion."1.0.12" { profileName = "__noProfile"; };
    };
  });
  
  "unknown".member-b."0.1.0" = overridableMkRustCrate (profileName: rec {
    name = "member-b";
    version = "0.1.0";
    registry = "unknown";
    src = fetchCrateLocal (workspaceSrc + "/member-b");
    dependencies = {
      rustversion = buildRustPackages."git+https://github.com/dtolnay/rustversion".rustversion."1.0.12" { profileName = "__noProfile"; };
    };
  });
  
  "git+https://github.com/dtolnay/rustversion".rustversion."1.0.12" = overridableMkRustCrate (profileName: rec {
    name = "rustversion";
    version = "1.0.12";
    registry = "git+https://github.com/dtolnay/rustversion";
    src = fetchCrateGit {
      url = https://github.com/dtolnay/rustversion;
      name = "rustversion";
      version = "1.0.12";
      rev = "a85f2db274e1367a945a83ed4fe5a7a53d8f4f0e";};
  });
  
  "git+https://github.com/dtolnay/rustversion".rustversion."1.0.12" = overridableMkRustCrate (profileName: rec {
    name = "rustversion";
    version = "1.0.12";
    registry = "git+https://github.com/dtolnay/rustversion";
    src = fetchCrateGit {
      url = https://github.com/dtolnay/rustversion;
      name = "rustversion";
      version = "1.0.12";
      rev = "a85f2db274e1367a945a83ed4fe5a7a53d8f4f0e";};
  });
  
}
