{config, pkgs, self, system,...}:
let
  unwrapFlakeInput = input: if self.inputs.${input} ? defaultPackage then self.inputs.${input}.defaultPackage.${system} else self.inputs.${input}.packages.${system}.default;
in {
  imports = import ./modules;
  home.username = "sidharta";
  home.homeDirectory = "/home/sidharta";
  nixpkgs.config.allowUnfree = true;

  programs.home-manager.enable = true;

  xsession.enable = true;
  xsession.windowManager.bspwm = import ./home/import/bspwm.nix { inherit config pkgs; };

  home.packages = with pkgs; [
    # === Regular Desktop ===
    btop
    firefox
    rofi
    xclip
    peek
    playerctl
    mpc-cli
    pamixer
    mpv
    yazi
    bat
	ripgrep

    orca-slicer
    (unwrapFlakeInput "neovim-with-plugins")

	# Broken?
	# plover.dev

    # === Non free ===
    discord
    telegram-desktop
	
    # === Fonts ===
    jetbrains-mono

    # === Neovim plugins ===
    sqlite
    gnumake
    xclip
  ];

  home.stateVersion = "24.05";

  programs.wezterm = import ./home/import/wezterm.nix { inherit; };
  programs.eww = import ./home/import/eww.nix { inherit; };
  programs.zsh = import ./home/import/zsh.nix { inherit pkgs; };
  programs.starship = import ./home/import/starship.nix { inherit; };
  programs.git = import ./home/import/git.nix { inherit; };
  programs.btop.enable = true;

  services.flameshot.enable = true;
  services.picom = import ./home/import/picom.nix { inherit config pkgs; };
  services.sxhkd-systemd = import ./home/import/sxhkd.nix { inherit config pkgs; };
  services.wallpaper-manager = import ./home/import/wallpaper-manager.nix {  inherit unwrapFlakeInput; };
  services.syncplay = import ./home/import/syncplay.nix { inherit; };

  systemd.user.startServices = true;
  systemd.user.services = import ./systemd-services.nix { inherit pkgs unwrapFlakeInput; };
}
