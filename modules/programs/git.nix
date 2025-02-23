{...}: {
  programs.git = {
    enable = true;
    userName = "snek-git";
    userEmail = "felo.markosyan@gmail.com";
    
    delta = {
      enable = true;
      options = {
        navigate = true;
        line-numbers = true;
        plus-style = "syntax '#fee801'";
        minus-style = "syntax '#c5003c'";
        plus-emph-style = "syntax '#fee801'";
        minus-emph-style = "syntax '#880425'";
        line-numbers-plus-style = "'#fee801'";
        line-numbers-minus-style = "#c5003c";
        commit-decoration-style = "bold '#c5003c'";
        file-style = "bold '#54c1e6'";
        file-decoration-style = "none";
        hunk-header-style = "syntax bold";
        hunk-header-decoration-style = "none";
        side-by-side = true;
      };
    };

    extraConfig = {
      core = {
        sshCommand = "ssh -i ~/.ssh/id_ed25519";
        editor = "nvim";
      };
      credential = {
        helper = "manager";
        credentialStore = "cache";
      };
      pull.rebase = true;
      push.autoSetupRemote = true;
      merge.conflictstyle = "diff3";
      diff.colorMoved = "default";
      init.defaultBranch = "main";
    };

    includes = [
      {
        condition = "gitdir:~/work/picsart/";
        contents = {
          user = {
            name = "feliks.markosyan";
            email = "feliks.markosyan@picsart.com";
          };
        };
      }
    ];
  };

  home.file.".config/git/ignore".text = ''
    .DS_Store
    .direnv
    .env
    .envrc
    .idea
    .vscode
    *.swp
    *~
  '';
} 