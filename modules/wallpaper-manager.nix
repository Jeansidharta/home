{ config, lib, pkgs, ... }:
with lib;

let
  cfg = config.services.wallpaper-manager;
  isTruthy = v: v != null && v != false && v != "";
in
 
{
  imports = [];
  options.services.wallpaper-manager = {
    enable = mkEnableOption "Enable syncplay";

    wallpapers-dir = mkOption {
      type = types.str;
      description = "Directory containing the user's wallpapers";
      apply = v: if isTruthy v then "--wallpapers-dir ${toString v}" else "";
      default = "~/wallpapers";
    };

    cache-dir = mkOption {
      type = types.str;
      description = "Where the program's cache will be stored";
      apply = v: if isTruthy v then "--cache-dir ${toString v}" else "";
      default = "~/.local/state/wallpaper-manager";
    };


    package = mkOption {
      type = types.package;
      description = "The wallpaper manager package";
    };

    enableZshIntegration = mkEnableOption "Enable Zsh integration";
  };

  config = let
    optionCommandLine = optionName: builtins.getAttr optionName cfg;
    commandLineOptions = concatMapStringsSep " " optionCommandLine [
      "wallpapers-dir"
      "cache-dir"
    ];
    execCommand = "${cfg.package}/bin/wallpaper-manager ${commandLineOptions}";

  in mkIf cfg.enable {
    assertions = [];

    home.packages = with pkgs; [ cfg.package sxiv xwinwrap ffmpeg mpv ];

    programs.zsh = mkIf cfg.enableZshIntegration {
      shellAliases = { "wallpaper-manager" = execCommand; };
      # initExtra = ''
      #   if [[ $TERM != "dumb" ]]; then
      #     eval "$(${pkgs.eww}/bin/eww shell-completions --shell zsh)"
      #   fi
      # ''
    };

    xdg.configFile."wallpaper-manager/config.toml".source = (pkgs.formats.toml {}).generate "wallpaper-manager-config" {};

    systemd.user.services.wallpaper-manager = let
      path = lib.strings.concatStringsSep ":" (with pkgs; [
        "${sxiv}/bin"
        "${mpv}/bin"
        "${xwinwrap}/bin"
        "${ffmpeg}/bin"
      ]);
    in {
      Unit = {
        Description = "Wallpaper manager";
      };
      Install = {
        WantedBy = [ "graphical-session.target" ];
      };
      Service = {
        ExecStart = execCommand + " daemon";
	ExecSearchPath = path;
      };
    };
  };
}
