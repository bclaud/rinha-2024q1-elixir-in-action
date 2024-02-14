{
  description = "Elixir API flake";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nix2container.url = "github:nlewo/nix2container";
  };

  outputs = { self, nixpkgs, nix2container, ... }:
    let
      systems = [
        "aarch64-linux"
        "x86_64-linux"
      ];

      eachSystem = with nixpkgs.lib; f: foldAttrs mergeAttrs { }
        (map (s: mapAttrs (_: v: { ${s} = v; }) (f s)) systems);
    in
    eachSystem (system:
      let
        inherit (nixpkgs.lib) optional;
        pkgs = (import nixpkgs {
          inherit system;
        }).pkgsMusl;

        nix2containerPkgs = nix2container.packages.${system};
      in
      with pkgs;
      {


        packages = rec {
          default = callPackage ./default.nix { };

          container = nix2containerPkgs.nix2container.buildImage {
            name = "rinha";
            tag = "latest";
            copyToRoot = pkgs.buildEnv {
              name = "image-root";
              paths = [ default pkgs.bash ];
              pathsToLink = [ "/bin" ];
            };

            config = {
              CMD = ["sh" "-c" "bin/rinha start" ];
              Env = [
                "USER=nobody"
                "LC_ALL=en_US.UTF-8"
                "LANG=en_US.UTF-8"
                "RELEASE_COOKIE=RINHA"
              ];
              ExposedPorts = {
                "9999/tcp" = { };
              };
            };
          };
        };

        formatter = nixpkgs-fmt;

        devShells.default = mkShell {
          name = "rinha-elixir-shell";
          buildInputs = with pkgs; [ beam_minimal.packages.erlang_26.elixir_1_16 ];
          #LOCALE_ARCHIVE = if pkgs.stdenv.isLinux then "${pkgs.glibcLocalesUtf8}/lib/locale/locale-archive" else "";
        };
      }
    );

}
