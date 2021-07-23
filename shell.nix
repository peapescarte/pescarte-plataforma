{ pkgs ? import <nixpkgs> {} }:

with pkgs;

let
  elixir_1_12 = beam.packages.erlangR24.elixir.override {
    version = "1.12.2";
    minimumOTPVersion = "24";
    sha256 = "1f8b63x2klhdz1fq1dgbrqs7x6rq309abzq48gicmd0vprfhc641";
  };
in mkShell {
  name = "fuschia_dev";

  # define packages to install with special handling for OSX
  buildInputs = [
    gnumake
    gcc
    readline
    openssl
    zlib
    libxml2
    curl
    libiconv
    # my elixir derivation
    elixir_1_12
    glibcLocales
    nodejs-12_x
    yarn
    postgresql
  ] ++ lib.optional stdenv.isLinux [
        inotify-tools
        # observer gtk engine
        gtk-engine-murrine
      ]
    ++ lib.optionals stdenv.isDarwin (with darwin.apple_sdk.frameworks; [
        CoreFoundation
        CoreServices
      ]);


  # define shell startup command
  shellHook = ''
    # create local tmp folders
    mkdir -p .nix-mix
    mkdir -p .nix-hex
  '';

  # elixir local PATH
  # this allows mix to work on the local directory
  MIX_HOME = "./.nix-mix";
  HEX_HOME = "./.nix-hex";
  PATH = "$MIX_HOME/bin:$HEX_HOME/bin::$PATH";
  ERL_AFLAGS = "-kernel shell_history enabled";
  # to not conflict with your host elixir
  # version and supress warnings about standard
  # libraries
  ERL_LIBS = "$HEX_HOME/lib/erlang/lib";

  # PpostgrSQL vars
  PGUSER = "pescarte";
  PGPASSWORD = "pescarte";
  }
