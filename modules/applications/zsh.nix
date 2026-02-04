{
  config,
  inputs,
  self,
  ...
}:
let
  meta = config.flake.meta;
  dev-shell-list = builtins.concatStringsSep "\n" (builtins.attrNames config.flake.customDevShells);
in
{
  flake.homeModules.zsh =
    { lib, pkgs, ... }:
    {
      programs.zsh = {
        enable = meta.defaults.shell == "zsh";
        enableCompletion = true;
        enableAutosuggestions = true;
        oh-my-zsh = {
          enable = true;
          plugins = [
            "git"
            "fzf"
          ];
          theme = "robbyrussell";
        };
        initContent = ''
          eval "$(direnv hook zsh)"
          function ex {
             if [ -z "$1" ]; then
                # display usage if no parameters given
                echo "Usage: extract <path/file_name>.<zip|rar|bz2|gz|tar|tbz2|tgz|Z|7z|xz|ex|tar.bz2|tar.gz|tar.xz>"
                echo "       extract <path/file_name_1.ext> [path/file_name_2.ext] [path/file_name_3.ext]"
             else
                for n in "$@"
                do
                  if [ -f "$n" ] ; then
                      case "''${n%,}" in
                        *.cbt|*.tar.bz2|*.tar.gz|*.tar.xz|*.tbz2|*.tgz|*.txz|*.tar)
                        ${pkgs.gnutar}/bin/tar xvf "$n"       ;;
                        *.lzma)      unlzma ./"$n"      ;;
                        *.bz2)       bunzip2 ./"$n"     ;;
                        *.cbr|*.rar)       unrar x -ad ./"$n" ;;
                        *.gz)        gunzip ./"$n"      ;;
                        *.cbz|*.epub|*.zip)       unzip ./"$n"       ;;
                        *.z)         uncompress ./"$n"  ;;
                        *.7z|*.arj|*.cab|*.cb7|*.chm|*.deb|*.dmg|*.iso|*.lzh|*.msi|*.pkg|*.rpm|*.udf|*.wim|*.xar)
                        ${pkgs.p7zip}/bin/7z x ./"$n"        ;;
                        *.xz)        unxz ./"$n"        ;;
                        *.exe)       cabextract ./"$n"  ;;
                        *.cpio)      cpio -id < ./"$n"  ;;
                        *.cba|*.ace)      unace x ./"$n"      ;;
                        *)
                        echo "Unsupported format"
                        return 1
                        ;;
                      esac
                  else
                      echo "'$n' - file does not exist"
                      return 1
                  fi
                done
             fi
          }

          function fnew {
            if [ -d "$1" ]; then
              echo "Directory \"$1\" already exists!"
              return 1
            fi
            nix flake new $1 --template ${self}/dev-shells#$2
            cd $1
            direnv allow
          }

          function finit {
            nix flake init --template ${self}/dev-shells#$1
            direnv allow
          }

          function flist {
            echo "${dev-shell-list}"
          }

          function cgen {
            if [ -d "$1" ]; then
              echo "Directory \"$1\" already exists!"
              return 1
            fi
            nix flake new $1 --template ${self}/dev-shells#c-cpp
            cd $1
            cat ~/.config/zsh/templates/ListTemplate.txt >> CMakeLists.txt
            mkdir src
            mkdir include
            cat ~/.config/zsh/templates/HelloWorldTemplate.txt >> src/main.cpp
            direnv allow
          }

          function crun {
            #VAR=''${1:-.}
            mkdir build 2> /dev/null
            cmake -B build
            cmake --build build
            build/main
          }

          function cbuild {
            mkdir build 2> /dev/null
            cmake -B build
            cmake --build build
          }
          function ns {
            nix shell nixpkgs#$1
          }
          f() {
              local fd_options fzf_options target

              fd_options=(
                  --hidden
                  --type directory
              )

              fzf_options=(
                  --preview='tree -L 1 {}'
                  --bind=ctrl-space:toggle-preview
                  --exit-0
              )

              target="$(fd . "''${1:-/home/paul}" ''${fd_options[@]} | fzf "''${fzf_options[@]}")"

              cd "$target" || return 1
          }

          clear
          fastfetch
        '';
        shellAliases = {
          dots = "cd ~/nixconf";
          proj = "cd ~/projects";
          nconf = "cd ~/neovim";
        };
      };
      home.packages = lib.mkAfter (
        with pkgs;
        [
          fzf
          fd
          tree
          fastfetch
        ]
      );
    };
}
