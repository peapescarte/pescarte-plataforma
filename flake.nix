{
  description = ''
    Plataforma PEA Pescarte
  '';

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-21.11";
    unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    utils.url = "github:gytis-ivaskevicius/flake-utils-plus";
  };

  outputs = inputs@{ self, nixpkgs, unstable, utils }:
    utils.lib.mkFlake rec {
      inherit self inputs;

      supportedSystems = [ "x86_64-linux" ];

      outputsBuilder = channels: {
        packages = { inherit (channels.nixpkgs) package-from-overlays; };
        devShell = channels.unstable.mkShell {
          name = "fuschia";
          buildInputs = with channels.unstable; [
            gnumake
            gcc
            readline
            openssl
            zlib
            libxml2
            curl
            libiconv
            # my elixir derivation
            # exDev
            elixir
            beamPackages.rebar3
            glibcLocales
            postgresql
            confluent-platform
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
      };
    };
}
