{
  description = "Home Manager configuration of sidharta";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    neovim-with-plugins = { url = "path:./home/neovim"; inputs.nixpkgs.follows = "nixpkgs";  };
    wallpaper-manager = { url = "path:/home/sidharta/projects/wallpaper-manager"; inputs.nixpkgs.follows = "nixpkgs"; };
    bspwm-desktops-report = { url = "path:./home/raw/eww/scripts/bspwm-desktops-report"; inputs.nixpkgs.follows = "nixpkgs"; };
    window-title-watcher = { url = "path:./home/raw/eww/scripts/window-title-watcher"; inputs.nixpkgs.follows = "nixpkgs"; };
    eww-bar-selector = { url = "path:./scripts/eww-bar-selector"; inputs.nixpkgs.follows = "nixpkgs"; };
    volume-watcher = { url = "path:./home/raw/eww/scripts/volume-watcher"; inputs.nixpkgs.follows = "nixpkgs"; };
  };

  outputs = { self, nixpkgs, home-manager, ... }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      homeConfigurations."sidharta" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        modules = [ ./home.nix ];

        # Pass through arguments to home.nix
        extraSpecialArgs = { inherit self system; };
      };
    };
}
