{
  description = "Plataforma Digital PEA Pescarte";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    systems.url = "github:nix-systems/default";
  };

  outputs = {
    flake-parts,
    systems,
    ...
  } @ inputs:
    flake-parts.lib.mkFlake {inherit inputs;} {
      systems = import systems;
      perSystem = {
        pkgs,
        system,
        ...
      }: let
        inherit (pkgs.beam.interpreters) erlang_27;
        inherit (pkgs.beam) packagesWith;
        beam = packagesWith erlang_27;

        elixir_1_18 = beam.elixir.override {
          version = "1.18.2";
          src = pkgs.fetchFromGitHub {
            repo = "elixir";
            owner = "elixir-lang";
            rev = "v1.18.2";
            sha256 = "sha256-8FhUKAaEjBBcF0etVPdkxMfrnR5niU40U8cxDRJdEok=";
          };
        };

        supabase-cli = pkgs.supabase-cli.overrideAttrs (old: {
          version = "2.15.8";
          src = pkgs.fetchFromGitHub {
            owner = "supabase";
            repo = "cli";
            rev = "v2.15.8";
            hash = "sha256-ha3wY2uzC93LlO6a/sgHg2uvU+0+PD/982bzIo0rcBE=";
          };
          vendorHash = "sha256-1IVdsW8vdu2c8ht6d/+yAiHnu5Cwe46QCgUA9F8rnEM=";
        });
      in {
        _module.args.pkgs = import inputs.nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };
        devShells.default = with pkgs;
          mkShell {
            name = "peapescarte";
            packages = with pkgs;
              [elixir_1_18 supabase-cli nodejs ghostscript zlib postgresql flyctl pass]
              ++ lib.optional stdenv.isLinux [inotify-tools chromium]
              ++ lib.optional stdenv.isDarwin [
                darwin.apple_sdk.frameworks.CoreServices
                darwin.apple_sdk.frameworks.CoreFoundation
              ];
          };
      };
    };
}
