#!/bin/bash

ASSETS=$PWD/.

function install_vim_plug
{
	echo ""
	echo "== Install Vim Plug =="
	if [ ! -f "${XDG_DATA_HOME:-$HOME/.local/share}/nvim/site/autoload/plug.vim" ]; then
		sh -c 'curl -sfLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim \
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

components=("kitty" "nvim" "macchina")
for comp in "${components[@]}" ; do :
	echo -n "installing: $comp "
	ln -svf "$PWD/$comp" "$HOME/.config/"
	echo done
done
ln -svf "$PWD/.bashrc" "$HOME/"

echo ""
echo "[info] open nvim and run :PlugInstall"
