{ config, lib, pkgs, ... }:

with lib;
{
  options.modules.zsh = {
    enable = mkOption { type = types.bool; default = false; };
  };

  config = mkIf config.modules.zsh.enable {
    home.packages = [
      pkgs.zsh
    ];

    programs.zsh.enable = true;

    programs.zsh.enableCompletion = true;
    programs.zsh.enableAutosuggestions = true;

    programs.zsh.autocd = true;

    programs.zsh.oh-my-zsh.enable = true;
    programs.zsh.oh-my-zsh.plugins = [ "git" "sudo" ];
    programs.zsh.oh-my-zsh.theme = "afowler";

    # home-manager's zsh doesn't support the syntax highlighting plugin, so fetch it ourselves...
    programs.zsh.plugins = [
      {
        name = "zsh-syntax-highlighting";
        src = pkgs.fetchFromGitHub {
          owner = "zsh-users";
          repo = "zsh-syntax-highlighting";
          rev = "0.7.1";
          sha256 = "03r6hpb5fy4yaakqm3lbf4xcvd408r44jgpv4lnzl9asp4sb9qc0";
        };
      }
    ];

    programs.zsh.initExtraFirst = ''
      # == Start modules/zsh.nix ==

      if [ -d "$HOME/bin" ] ; then
          PATH="$HOME/bin:$PATH"
      fi
      
      # set PATH so it includes user's private bin if it exists
      if [ -d "$HOME/.local/bin" ] ; then
          PATH="$HOME/.local/bin:$PATH"
      fi
      
      if [ -e "$HOME/.nix-profile/etc/profile.d/nix.sh" ]; then . "$HOME/.nix-profile/etc/profile.d/nix.sh"; fi

      # == End modules/zsh.nix ==
    '';

    programs.zsh.initExtra = mkIf config.globals.isWsl ''
      # == Start modules/zsh.nix ==

      WSL_HOST=$(cat /etc/resolv.conf | grep nameserver | awk '{print $2}')
      export WSL_HOST=$WSL_HOST
      export DISPLAY=$WSL_HOST:0.0
      export LIBGL_ALWAYS_INDIRECT=1

      # == End modules/zsh.nix ==
    '';
  };
}