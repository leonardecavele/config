#! /bin/bash

components=("kitty" "nvim" "macchina")

for comp in "${components[@]}" ; do :
	ln -sv "$PWD/$comp/.config/$comp" "$HOME/.config/"
done

ln -sv "$PWD/.bashrc" "$HOME/"
