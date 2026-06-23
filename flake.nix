{
  description = "My NVF configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nvf.url = "github:notashelf/nvf";
    qml-go-lsp.url = "github:cushycush/qml-language-server";
  };

  outputs = {
    nixpkgs,
    nvf,
    qml-go-lsp,
    ...
  }: let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};

    Neovim = nvf.lib.neovimConfiguration {
      inherit pkgs;
      modules = [./NVF.nix];

      extraSpecialArgs = {inherit qml-go-lsp;};
    };
  in {
    packages.${system}.default = Neovim.neovim;
    nixosModules.default = ./NVF.nix;
  };
}
