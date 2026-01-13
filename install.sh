#! /bin/bash

components=("kitty" "nvim" "macchina")

for comp in "${components[@]}" ; do :
	ln -svf "$PWD/$comp" "$HOME/.config/"
done

ln -svf "$PWD/.bashrc" "$HOME/"
