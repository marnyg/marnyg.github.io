{
  description = "NixOS configuration";

  inputs = {

    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    flake-parts.inputs.nixpkgs-lib.follows = "nixpkgs";
    agenix.url = "github:ryantm/agenix";

    treefmt-nix.url = "github:numtide/treefmt-nix";
    devenv.url = "github:cachix/devenv";
    agenix-shell.url = "github:aciceri/agenix-shell";

    nix2container.url = "github:nlewo/nix2container";
    nix2container.inputs = { nixpkgs.follows = "nixpkgs"; };

    argocd.url = "https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml";
    argocd.flake = false;
  };

  outputs = inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; }
      {
        systems = [ "x86_64-linux" ];
        imports = [
          inputs.agenix-shell.flakeModules.default
          inputs.treefmt-nix.flakeModule
          inputs.devenv.flakeModule
          ./nix/dev-shells.nix
        ];
      };
}
