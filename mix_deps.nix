{ lib, beamPackages, overrides ? (x: y: {}) }:

let
  buildRebar3 = lib.makeOverridable beamPackages.buildRebar3;
  buildMix = lib.makeOverridable beamPackages.buildMix;
  buildErlangMk = lib.makeOverridable beamPackages.buildErlangMk;

  self = packages // (overrides self packages);

  packages = with beamPackages; with self; {
    cowboy = buildErlangMk rec {
      name = "cowboy";
      version = "2.10.0";

      src = fetchHex {
        pkg = "cowboy";
        version = "${version}";
        sha256 = "3afdccb7183cc6f143cb14d3cf51fa00e53db9ec80cdcd525482f5e99bc41d6b";
      };

      beamDeps = [ cowlib ranch ];
    };

    cowboy_telemetry = buildRebar3 rec {
      name = "cowboy_telemetry";
      version = "0.4.0";

      src = fetchHex {
        pkg = "cowboy_telemetry";
        version = "${version}";
        sha256 = "7d98bac1ee4565d31b62d59f8823dfd8356a169e7fcbb83831b8a5397404c9de";
      };

      beamDeps = [ cowboy telemetry ];
    };

    cowlib = buildRebar3 rec {
      name = "cowlib";
      version = "2.12.1";

      src = fetchHex {
        pkg = "cowlib";
        version = "${version}";
        sha256 = "163b73f6367a7341b33c794c4e88e7dbfe6498ac42dcd69ef44c5bc5507c8db0";
      };

      beamDeps = [];
    };

    jason = buildMix rec {
      name = "jason";
      version = "1.4.1";

      src = fetchHex {
        pkg = "jason";
        version = "${version}";
        sha256 = "fbb01ecdfd565b56261302f7e1fcc27c4fb8f32d56eab74db621fc154604a7a1";
      };

      beamDeps = [];
    };

    mime = buildMix rec {
      name = "mime";
      version = "2.0.5";

      src = fetchHex {
        pkg = "mime";
        version = "${version}";
        sha256 = "da0d64a365c45bc9935cc5c8a7fc5e49a0e0f9932a761c55d6c52b142780a05c";
      };

      beamDeps = [];
    };

    plug = buildMix rec {
      name = "plug";
      version = "1.15.3";

      src = fetchHex {
        pkg = "plug";
        version = "${version}";
        sha256 = "cc4365a3c010a56af402e0809208873d113e9c38c401cabd88027ef4f5c01fd2";
      };

      beamDeps = [ mime plug_crypto telemetry ];
    };

    plug_cowboy = buildMix rec {
      name = "plug_cowboy";
      version = "2.7.0";

      src = fetchHex {
        pkg = "plug_cowboy";
        version = "${version}";
        sha256 = "d85444fb8aa1f2fc62eabe83bbe387d81510d773886774ebdcb429b3da3c1a4a";
      };

      beamDeps = [ cowboy cowboy_telemetry plug ];
    };

    plug_crypto = buildMix rec {
      name = "plug_crypto";
      version = "2.0.0";

      src = fetchHex {
        pkg = "plug_crypto";
        version = "${version}";
        sha256 = "53695bae57cc4e54566d993eb01074e4d894b65a3766f1c43e2c61a1b0f45ea9";
      };

      beamDeps = [];
    };

    ranch = buildRebar3 rec {
      name = "ranch";
      version = "1.8.0";

      src = fetchHex {
        pkg = "ranch";
        version = "${version}";
        sha256 = "49fbcfd3682fab1f5d109351b61257676da1a2fdbe295904176d5e521a2ddfe5";
      };

      beamDeps = [];
    };

    telemetry = buildRebar3 rec {
      name = "telemetry";
      version = "1.2.1";

      src = fetchHex {
        pkg = "telemetry";
        version = "${version}";
        sha256 = "dad9ce9d8effc621708f99eac538ef1cbe05d6a874dd741de2e689c47feafed5";
      };

      beamDeps = [];
    };
  };
in self

