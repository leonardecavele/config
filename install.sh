#! /bin/bash

components=("kitty" "fish" "nvim" "backgrounds" "macchina")

for comp in "${components[@]}" ; do :
	ln -sv "$PWD/$comp/.config/$comp" "$HOME/.config/"
done
