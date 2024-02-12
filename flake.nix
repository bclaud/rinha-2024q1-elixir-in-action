{
  description = "Elixir API flake";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
  };

  outputs = { self, nixpkgs }:
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
        pkgs = import nixpkgs {
          inherit system;
        };
      in
      with pkgs;
      {

        packages.hello = hello;

        formatter = nixpkgs-fmt;

        devShells.default = mkShell {
          name = "rinha-elixir-shell";
          buildInputs = with pkgs; [ beam.packages.erlang_26.elixir_1_16 ];
          LOCALE_ARCHIVE = if pkgs.stdenv.isLinux then "${pkgs.glibcLocalesUtf8}/lib/locale/locale-archive" else "";
        };
      }
    );

}
