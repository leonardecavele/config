#!/bin/bash

if /usr/bin/sudo -n true >/dev/null 2>&1 && command -v pacman >/dev/null 2>&1; then
	echo "sudo + pacman available"

	HOST_HOME=$HOME
	JUNEST_HOME=$HOME
else
	echo "sudo and/or pacman not available"

	if [ -z "${HOST_HOME+x}" ]; then
		HOST_HOME=$HOME
	fi
	JUNEST_HOME=$HOST_HOME/.junest$HOST_HOME

	command -v junest >/dev/null 2>&1 && break

	git clone https://github.com/fsquillace/junest.git ~/.local/share/junest
	export PATH=~/.local/share/junest/bin:$PATH
	junest setup
	junest -n sudo pacman -S --noconfirm archlinux-keyring
	junest -n sudo pacman -Syu --noconfirm
	junest -n sudo pacman -S --noconfirm kitty
	junest -n sudo pacman -S --noconfirm nvim
	junest -n sudo pacman -S --noconfirm btop
	junest -n sudo pacman -S --noconfirm macchina
	junest -n sudo pacman -S --noconfirm openssh
fi

# install vim plug
function install_vim_plug
{
	echo ""
	echo "== Install Vim Plug =="
	if [ ! -f "${XDG_DATA_HOME:-$JUNEST_HOME/.local/share}/nvim/site/autoload/plug.vim" ]; then
		sh -c 'curl -sfLo "${XDG_DATA_HOME:-$JUNEST_HOME/.local/share}"/nvim/site/autoload/plug.vim \
			--create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim' \
			1>/dev/null
		status=$?
		if [ $status -ne 0 ]; then
			echo "failed";
			exit 1
		fi
	fi
	echo "done"
}

# install kitty
echo -n "copy kitty HOST_HOME"
ln -svf "$PWD/kitty" "$HOST_HOME/.config/"

# install components
components=("kitty" "nvim" "macchina")
for comp in "${components[@]}" ; do :
	echo -n "installing: $comp "
	ln -svf "$PWD/$comp" "$JUNEST_HOME/.config/"
	echo done
done
ln -svf "$PWD/.bashrc" "$JUNEST_HOME/"

# info
echo ""
echo "[info] open nvim and run :PlugInstall"
