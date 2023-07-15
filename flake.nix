{
  description = "ktaf-nixos";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-23.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-parts.url = "github:hercules-ci/flake-parts";
    # used for development
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = inputs@{ self, nixpkgs, home-manager, treefmt-nix, ... }:
    let
      user = "kourosh";
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
      lib = nixpkgs.lib;
    in {
      nixosConfigurations = {
        ${user} = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit user; };
          modules = [
            ./configuration.nix
            ./hardware-configuration.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = { inherit user; };
              home-manager.users.${user} = import ./modules/home.nix;
            }
          ];
        };
      };
      flake-parts.lib.mkFlake = {
        inherit inputs;
      } {
        systems = [ "x86_64-linux" ];
        imports = [
          inputs.flake-root.flakeModule
          inputs.mission-control.flakeModule
          inputs.treefmt-nix.flakeModule
        ];
        perSystem = { config, ... }: {
          treefmt = {
            projectRootFile = "flake.nix";
            programs.mdsh.enable = true;
            programs.nixpkgs-fmt.enable = true;
            programs.shellcheck.enable = true;
            programs.shfmt.enable = true;
            programs.prettier.enable = true;
            settings.formatter.prettier.options = [ "--prose-wrap" "always" ];
            settings.formatter.shellcheck.options = [ "-s" "bash" ];
            programs.beautysh = {
              enable = true;
              indent_size = 4;
            };
            # Here you can specify the formatters to use
            programs.terraform.enable = true;
            # ...and options
            programs.terraform.package = nixpkgs.terraform_1;
          };
          formatter = config.treefmt.build.wrapper;
        };
      };
    };
}

#nixos-23.05

