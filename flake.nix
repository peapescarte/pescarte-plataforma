{
  description = "Plataforma Digital PEA Pescarte";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    elixir-overlay.url = "github:zoedsoupe/elixir-overlay";
  };

  outputs = {
    nixpkgs,
    elixir-overlay,
    ...
  }: let
    inherit (nixpkgs.lib) genAttrs;
    inherit (nixpkgs.lib.systems) flakeExposed;
    forAllSystems = f:
      genAttrs flakeExposed (
        system: let
          overlays = [elixir-overlay.overlays.default];
          pkgs = import nixpkgs {inherit system overlays;};
        in
          f pkgs
      );
  in {
    devShells = forAllSystems (pkgs: let
      inherit (pkgs.beam.interpreters) erlang_27;
    in {
      default = pkgs.mkShell {
        name = "peapescarte";
        packages = with pkgs;
          [elixir-bin."1.19.0-rc.0" erlang_27 supabase-cli nodejs ghostscript zlib postgresql flyctl pass]
          ++ lib.optional stdenv.isLinux [inotify-tools chromium]
          ++ lib.optional stdenv.isDarwin [
            darwin.apple_sdk.frameworks.CoreServices
            darwin.apple_sdk.frameworks.CoreFoundation
          ];
      };
    });
  };
}
