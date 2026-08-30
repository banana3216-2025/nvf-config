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

    main = nvf.lib.neovimConfiguration {
      inherit pkgs;
      modules = [./main.nix];

      extraSpecialArgs = {inherit qml-go-lsp;};
    };

    minimal = nvf.lib.neovimConfiguration {
      inherit pkgs;
      modules = [./minimal.nix];
    };
  in {
    packages.${system} = {
      default = main.neovim;
      minimal = minimal.neovim;
    };

    nixosModules.default = ./main.nix;
  };
}
