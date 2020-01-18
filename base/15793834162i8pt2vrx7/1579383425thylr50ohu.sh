#!/bin/bash

dir_1=$(kdialog --getexistingdirectory *);

if [ "$?" = 0 ]; then
	kdialog --msgbox "$dir_1";
elif [ "$?" = 1 ]; then
	kdialog --sorry "YOU CHOSE CANCEL";
else
	kdialog --error "ERROR";
fi;

#konsole -e mkdir $dir_1'/textures' $dir_1'/models' $dir_1'/other'
mkdir $dir_1'/textures' $dir_1'/models' $dir_1'/other'
exit 0
