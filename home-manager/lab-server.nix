{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./cli
  ];

  home.username = "sf";
  home.homeDirectory = "/home/sf";

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "24.05";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    mihomo
  ];

  programs.zsh.initExtraFirst = "# added by Nix installer
if [ -e /home/sf/.nix-profile/etc/profile.d/nix.sh ]; then
	. /home/sf/.nix-profile/etc/profile.d/nix.sh;
fi";


  programs.zsh.initExtra = "# proxy
function set-proxy() {
  export http_proxy=http://127.0.0.1:7890
  export https_proxy=http://127.0.0.1:7890
  export all_proxy=socks://127.0.0.1:7891
  echo 'Proxy Set'
}
function unset-proxy() {
  unset http_proxy https_proxy all_proxy
  echo 'Proxy Unset'
}";
}
