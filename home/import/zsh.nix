{pkgs, ...}:
{
  enable = true;
  autosuggestion.enable = true;
  shellAliases = {
    "hm" = "home-manager";
    "ses" = "systemctl --user";
    "vim" = "nvim";
    "vi" = "nvim";
    "ns" = "nix-shell";
    "ne" = "nix-env";
    "nb" = "nix-build";
  };
  initExtra = ''
    if [[ $TERM != "dumb" ]]; then
      eval "$(${pkgs.eww}/bin/eww shell-completions --shell zsh)"
    fi
  '';
}
