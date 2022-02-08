{
  description = ''
    TODO
  '';

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-21.11";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.x86_64-linux;

        exDev = pkgs.beam.packages.erlangR24.elixir.override {
          version = "1.13.2";
          minimumOTPVersion = "24";
          sha256 = "qv85aDP3RPCa1YBo45ykWRRZNanL6brNKDMPu9SZdbQ=";
        };
      in {
        devShell = pkgs.mkShell {
          name = "fuschia_dev";
          buildInputs = with pkgs; [
            gnumake
            gcc
            readline
            openssl
            zlib
            libxml2
            curl
            libiconv
            # my elixir derivation
            exDev
            beamPackages.rebar3
            glibcLocales
            postgresql
          ] ++ pkgs.lib.optional stdenv.isLinux [
                inotify-tools
                # observer gtk engine
                gtk-engine-murrine
              ]
            ++ pkgs.lib.optionals stdenv.isDarwin (with darwin.apple_sdk.frameworks; [
                CoreFoundation
                CoreServices
              ]);

         # define shell startup command
        shellHook = ''
          # create local tmp folders
          mkdir -p .nix-mix
          mkdir -p .nix-hex

          mix local.hex --force --if-missing
          mix local.rebar --force --if-missing

          # to not conflict with your host elixir
          # version and supress warnings about standard
          # libraries
          export ERL_LIBS="$HEX_HOME/lib/erlang/lib"
        '';
      };
    });
}
