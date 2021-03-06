{ config, lib, pkgs, ... }:

with lib;
{
  options.modules.git-enhanced = {
    enable = mkOption { type = types.bool; default = false; };
  };

  config = mkIf config.modules.git-enhanced.enable {
    home.packages = [
      pkgs.git
      pkgs.gh

      pkgs.delta
    ];

    # `home-manager` doesn't support the standard `programs.git.*` configuration options
    # within NixOS.
    #
    # This essentially does the same thing :-)
    home.file.".gitconfig" = {
      executable = false;
      text = ''
      [user]    
        email = me@cbailey.co.uk
        name = Chris Bailey

      [color]
        ui = true

      [core]
        pager = delta

      [interactive]
        diffFilter = delta --color-only

      [delta]
        features = side-by-side line-numbers decorations
        whitespace-error-style = 22 reverse

      [delta "decorations"]
        commit-decoration-style = bold yellow box ul
        file-style = bold yellow ul
        file-decoration-style = none

      [alias]
        # GH Core aliases
        gh          = "!f() { gh $@; \n }; f"
        gist        = "!f() { gh gist $@; \n }; f"
        issue       = "!f() { gh issue $@; \n }; f"
        pr          = "!f() { gh pr $@; \n }; f"
        release     = "!f() { gh release $@; \n }; f"
        repo        = "!f() { gh repo $@; \n }; f"

        alias       = "!f() { gh alias $@; \n }; f"
        api         = "!f() { gh api $@; \n }; f"
        auth        = "!f() { gh auth $@; \n }; f"
        completion  = "!f() { gh completion $@; \n }; f"
        config      = "!f() { gh config $@; \n }; f"
        secret      = "!f() { gh secret $@; \n }; f"
        ssh-key     = "!f() { gh ssh-key $@; \n }; f"

        # Custom aliases
        push-origin = "!f() { git push origin -u $(git rev-parse --abbrev-ref HEAD) $@; \n }; f"
        rewind      = "!f() { git checkout HEAD~$1; \n }; f"
        rewrite     = "!f() { git rebase -i HEAD~$1; \n }; f"
        gloat       = "!f() { git shortlog -sn; \n }; f"
      '';
    };
  };
}

