{ pkgs }:
with pkgs;

let
  beamPackages = beam_minimal.packagesWith beam_minimal.interpreters.erlang_26;
  elixir = beam_minimal.packages.erlang_26.elixir_1_16;
  pname = "rinha";
  version = "0.0.1";

  src = ./.;
  deps = import ./mix_deps.nix { inherit lib beamPackages; };

  #MixFodDeps only for reference
  mixFodDeps = beamPackages.fetchMixDeps {
    pname = "mix-deps-${pname}";
    inherit src version elixir;
    # nix will complain and tell you the right value to replace this with
    hash = "sha256-tct8GdhJe//FgGPemKBikVs6kW1KzxdTpgnaKP1vCeE=";
    mixEnv = "prod"; # default is "prod", when empty includes all dependencies, such as "dev", "test".
    # if you have build time environment variables add them here
    #MY_ENV_VAR="my_value";
  };

in
  beamPackages.mixRelease {
    inherit pname src version elixir ;

    mixNixDeps = deps;

    LC_ALL = "en_US.UTF-8";
    LANG = "en_US.UTF-8";
  }
