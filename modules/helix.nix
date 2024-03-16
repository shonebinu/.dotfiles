{
  config,
  pkgs,
  ...
}: {
  programs.helix = {
    enable = true;
    extraPackages = with pkgs; [
      marksman
      nil
      nodePackages.typescript-language-server
      vscode-langservers-extracted
      nodePackages.bash-language-server
      python311Packages.python-lsp-server
      alejandra
      emmet-ls
      black
      phpactor
      ltex-ls
      dprint
    ];
    settings = {
      theme = "onedark";
      editor = {
        line-number = "relative";
        cursorline = true;
        auto-format = true;
        mouse = false;
        auto-save = true;
        bufferline = "multiple";
        true-color = true;
      };
      editor.cursor-shape = {
        insert = "bar";
        normal = "block";
        select = "underline";
      };
      keys.normal = {
        esc = ["collapse_selection" "keep_primary_selection"];
      };
    };

    languages.language-server = {
      emmet-ls = {
        command = "emmet-ls";
        args = ["--stdio"];
      };
      phpactor = {
        command = "phpactor";
        args = ["language-server"];
      };
    };

    languages.language = [
      {
        name = "html";
        language-servers = ["vscode-html-language-server" "emmet-ls"];
      }
      {
        name = "css";
        language-servers = ["vscode-css-language-server" "emmet-ls"];
      }
      {
        name = "javascript";
        auto-format = true;
        formatter.command = "dprint";
        formatter.args = ["fmt" "--stdin" "jsx"];
        language-servers = ["typescript-language-server"];
      }
      {
        name = "markdown";
        auto-format = true;
        soft-wrap.enable = true;
        formatter.command = "dprint";
        formatter.args = ["fmt" "--stdin" "md"];
        language-servers = ["marksman" "ltex-ls"];
      }
      {
        name = "json";
        language-servers = ["vscode-json-language-server"];
      }
      {
        name = "bash";
        language-servers = ["bash-language-server"];
      }
      {
        name = "php";
        language-servers = ["phpactor"];
      }
      {
        name = "python";
        auto-format = true;
        formatter.command = "black";
        formatter.args = ["--quiet" "-"];
        language-servers = ["pylsp"];
      }
      {
        name = "nix";
        auto-format = true;
        formatter.command = "alejandra";
        language-servers = ["nil"];
      }
    ];
  };
}
