#!/bin/bash
pushd $(dirname "${0}") > /dev/null
basedir=$(pwd -L)
cd $basedir

function clone_project () {
	if [ ! -d $basedir/$1 ]; then
		echo "cloning $1"
		git clone --depth -1 $2
	else
	  echo "$1 already present will link it"
	fi
}

clone_project oh-my-zsh git@github.com:achamian/oh-my-zsh.git
clone_project rbenv git://github.com/sstephenson/rbenv.git

for f in oh-my-zsh zshrc rbenv
do
  test $f = "install" && continue
  dest="$HOME/.$f"
  file="$PWD/$f"
  if [ -e $dest ] || [ -h $dest ]; then
    if [ "$replace" != "a" ]; then 
      echo "$dest already exists, replace? [y/n/a] "
      read replace
    fi
    if [ "$replace" = "a" ] || [ "$replace" = "y" ]; then
      echo "linking $file to $dest..."
      rm -f $dest
      ln -s $file $dest
      test "$replace" != "a" && replace=""
    else
      echo "skipping $file as it already exists..."
    fi
  elif [ "$f" == "README" ]; then  
    echo "skipping README: $f."
  else
    echo "linking $file to $dest..."
    ln -s $file $dest
  fi
done

clone_project ruby-build git://github.com/sstephenson/ruby-build.git
cd $basedir/ruby-build
sh install.sh

# if [ ! -d $basedir/rbenv ]; then
# 	echo "cloning oh-my-zsh"
# 	git clone --depth -1 git@github.com:achamian/oh-my-zsh.git
# else
#   echo "oh-my-zsh already present will link it"
# fi

popd > /dev/null
