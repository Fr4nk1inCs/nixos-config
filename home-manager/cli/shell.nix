{pkgs, ...}: {
  home.packages = with pkgs; [
    file
  ];

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    history = {
      size = 50000;
      save = 10000;
      share = true;
      extended = true;
      expireDuplicatesFirst = true;
      ignoreDups = true;
      ignoreSpace = true;
    };

    historySubstringSearch = {
      enable = true;
      searchDownKey = [
        "^[[B"
        "^[OB"
      ];
      searchUpKey = [
        "^[[A"
        "^[OA"
      ];
    };

    shellAliases = {
      ":q" = "exit";
    };

    antidote = {
      enable = true;
      plugins = [
        "wbingli/zsh-wakatime"
        "Aloxaf/fzf-tab"
        "Freed-Wu/fzf-tab-source"
        "chisui/zsh-nix-shell"
      ];
    };

    localVariables = {
      LESSOPEN = "|~/.lessfilter %s";
    };

    initExtra = "setopt interactivecomments";
  };

  programs.starship = {
    enable = true;
  };

  home.file.".lessfilter" = {
    text = "#!/usr/bin/env sh
# this is a example of .lessfilter, you can change it
mime=$(file -bL --mime-type \"$1\")
category=\${mime%%/*}
kind=\${mime##*/}
if [ -d \"$1\" ]; then
	eza --git -hl --color=always --icons \"$1\"
elif [ \"$category\" = image ]; then
	chafa \"$1\"
	exiftool \"$1\"
elif [ \"$kind\" = vnd.openxmlformats-officedocument.spreadsheetml.sheet ] || \\
	[ \"$kind\" = vnd.ms-excel ]; then
	in2csv \"$1\" | xsv table | bat -ltsv --color=always
elif [ \"$category\" = text ]; then
	bat --color=always \"$1\"
elif [ \"$kind\" = json ]; then
    bat --color=always -l json \"$1\"
else
	bat --color=always \"$1\"
fi
# lesspipe.sh don't use eza, bat and chafa, it use ls and exiftool. so we create a lessfilter.";
    executable = true;
  };
}
