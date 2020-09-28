#!/usr/bin/env bash

copy-with-backup() {
	SOURCEFILE=$1
	TARGFILE=$2

	if [ -f "$TARGFILE" ]; then
		MD5SOURCE=$(md5sum "$SOURCEFILE" | cut -c1-33)
		MD5TARGET=$(md5sum "$TARGFILE" | cut -c1-33)
		if [ "$MD5SOURCE" == "$MD5TARGET" ]; then
			return
		else
			SUFFIX=\~$(date +%Y%m%d%H%M%S)
			BKTARG=$TARGFILE$SUFFIX
			mv "$TARGFILE" "$BKTARG"
		fi
	fi

	cp "$SOURCEFILE" "$TARGFILE"
}

dot-copy() {
	ORIGDIR=$1
	TARGDIR=$2

	STARTDIR=$(pwd)
	cd "$ORIGDIR" || exit
	for dotfile in dot-*; do
		targfile=.$(echo "$dotfile" | cut -c5-)
		copy-with-backup "$dotfile" "$TARGDIR/$targfile"
	done
	cd "$STARTDIR" || exit
}

create-dir() {
	DIRNAME=$1
	if [ ! -d "$DIRNAME" ]; then
		mkdir "$DIRNAME"
	fi
}

git-clone-or-pull() {
	GITURL=$1
	TARGDIR=$2

	if [ -d "$TARGDIR" ]; then
		git -C "$TARGDIR" branch --set-upstream-to=origin/master deploy
		git -C "$TARGDIR" pull
	else
		git clone "$GITURL" "$TARGDIR"
	fi
}

# Preserve the system-provided .bashrc as .bashrc_system
# .bashrc_system will be sourced by the .bashrc file
if [ ! -f ~/.bashrc_system ]; then
	if [ -f ~/.bashrc ]; then
		mv ~/.bashrc ~/.bashrc_system
	else
		echo \#no bashrc present on initial creation > ~/.bashrc_system
	fi
fi

dot-copy "bash" ~
create-dir ~/.ssh
dot-copy "vim" ~
create-dir ~/.vim
create-dir ~/.vim/autoload
# still using pathogen since some of my environments are forced to use vim 7.x
curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim
create-dir ~/.vim/bundle
git-clone-or-pull https://github.com/flazz/vim-colorschemes.git ~/.vim/bundle/colorschemes
git-clone-or-pull https://github.com/Shutnik/jshint2.vim ~/.vim/bundle/jshint2.vim
git-clone-or-pull https://github.com/scrooloose/nerdtree.git ~/.vim/bundle/nerdtree
git-clone-or-pull https://github.com/leafgarland/typescript-vim.git ~/.vim/bundle/typescript-vim
git-clone-or-pull https://github.com/vim-airline/vim-airline.git ~/.vim/bundle/vim-airline
git-clone-or-pull https://github.com/vim-airline/vim-airline-themes.git ~/.vim/bundle/vim-airline-themes
git-clone-or-pull https://github.com/qpkorr/vim-bufkill.git ~/.vim/bundle/vim-bufkill
git-clone-or-pull https://github.com/altercation/vim-colors-solarized.git ~/.vim/bundle/vim-colors-solarized
git-clone-or-pull https://github.com/tpope/vim-fugitive.git ~/.vim/bundle/vim-figitive
git-clone-or-pull https://github.com/pangloss/vim-javascript.git ~/.vim/bundle/vim-javascript
git-clone-or-pull https://github.com/jelera/vim-javascript-syntax.git ~/.vim/bundle/vim-javascript-syntax
git-clone-or-pull https://github.com/mxw/vim-jsx.git ~/.vim/bundle/vim-jsx
git-clone-or-pull https://github.com/vim-ruby/vim-ruby.git ~/.vim/bundle/vim-ruby
git-clone-or-pull git://github.com/tpope/vim-sensible.git ~/.vim/bundle/vim-sensible
git-clone-or-pull git://github.com/hashivim/vim-terraform.git ~/.vim/bundle/vim-terraform
git-clone-or-pull git://github.com/tpope/vim-unimpaired.git ~/.vim/bundle/vim-unimpaired
git-clone-or-pull https://github.com/vim-python/python-syntax.git ~/.vim/bundle/vim-python-syntax
git-clone-or-pull https://github.com/guns/xterm-color-table.vim.git ~/.vim/bundle/xterm-color-table.vim
git-clone-or-pull https://github.com/vim-syntastic/syntastic.git ~/.vim/bundle/syntastic



