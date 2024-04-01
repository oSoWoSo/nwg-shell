#!/usr/bin/bash

if [ "$(id -u)" == 0 ] ; then
   echo "Please don't run this script as root"
   exit 1
fi

# Don't continue script if any error occurs.
set -e

function yes_or_no {
    while true; do
        read -r -p "$* [y/n]: " yn
        case $yn in
            [Yy]*) choice="Y" ; return 0 ;;
            [Nn]*) choice="n" ; return 0 ;;
        esac
    done
}

# wget https://raw.github.com/nwg-piotr/nwg-shell/main/install/arch-dev.sh && chmod u+x arch-dev.sh && ./arch-dev.sh && rm ./arch-dev.sh
sudo xbps-install -Sy git man-db vi xdg-user-dirs

echo Initializing XDG user directories
xdg-user-dirs-update

echo "Adding $USER to video group"
sudo usermod -aG video $USER

echo
echo "You're about to select components, that need to be preinstalled for the key bindings to work."
echo "None of above is a shell dependency, and you're free to change them any time later."
echo

PS3="Select file manager: "
select fm in Thunar caja cfm clifm dolphin fff jeti-filemanager konqueror krusader lf lfm mc nautilus nemo pcmanfm pcmanfm-qt qtfm ranger rox shfm spacefm vifm xfe;
do
    break
done
echo

PS3="Select text editor: "
select editor in amp aoeui codelite dte e3 eclipse ed edbrowse emacs ex-vi geany gedit gnome-text-editor gtkedit gvim helix joe kakoune kate5 kibi ktexteditor kwrite leafpad lite-xl micro mle moe mousepad nano neovim notepadqq pluma sandy scite tau textadept tilde vile vim vim-huge vscode xed xedit;
do
    break
done
echo

PS3="Select web browser: "
select browser in badwolf browsh chromium dillo dooble edbrowse elinks eolie ephiphany falkon firefox firefox-esr flinks konqueror kristall links luakit lynx midori netsurf nyxt offpunk otter-browser qutebrowser surf vimb w3m;
do
    break
done
echo

echo "Installing selection: $fm $editor $browser"
sudo xbps-install -y $fm $editor $browser

#echo Installing Simon Ser GPG key, needed by the wlr-randr AUR package
#gpg --recv-key 0FDE7BE0E88F5E48

echo Installing nwg-shell
sudo xbps-install -y nwg-shell

echo "Starting from v0.5.0, nwg-shell supports Hyprland Wayland compositor."

echo
yes_or_no "Install Hyprland?"

if [ "$choice" == "Y" ] ; then
   echo "Installing Hyprland"
   sudo xbps-install -y hyprland wlr-randr
   echo Installing initial configuration
   nwg-shell-installer -w -hypr
else
   echo Installing initial configuration
   nwg-shell-installer -w
fi
