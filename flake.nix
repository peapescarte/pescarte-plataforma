{
  description = ''
    Plataforma PEA Pescarte
  '';

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs }:
    let
      systems = {
        linux = "x86_64-linux";
        darwin = "aarch64-darwin";
      };

      pkgs = system: import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };

      inputs = sys: with pkgs sys; [
        gnumake
        gcc
        readline
        openssl
        zlib
        libxml2
        curl
        libiconv
        elixir
        glibcLocales
        postgresql
        redpanda
      ] ++ lib.optional stdenv.isLinux [
        inotify-tools
        gtk-engine-murrine
      ];
      # o canal unstable está quebrado
      # ++ lib.optional stdenv.isDarwin [
      #   darwin.apple_sdk.frameworks.CoreServices
      #   darwin.apple_sdk.frameworks.CoreFoundation
      # ];
    in
    rec {
      devShells = {
        "${systems.linux}".default = with pkgs systems.linux; mkShell {
          name = "fuschia";
          buildInputs = inputs systems.linux;
        };

        "${systems.darwin}".default = with pkgs systems.darwin; mkShell {
          name = "fuschia";
          buildInputs = inputs systems.darwin;
        };
      };
    };
}
