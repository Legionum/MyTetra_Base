#!/bin/bash
#В данном скрипет используется функция kdialog
#очень полезная штука при работе в среде KDE
#данный экземпляр получает существующую директорию
#нужно выбрать нужную папку, в которой нужно создать три
#подпапки для проектов 3д-редактора и нажать "ОК"
dir_1=$(kdialog --getexistingdirectory *);
#диалоговые окна
if [ "$?" = 0 ]; then
	kdialog --msgbox "$dir_1";
elif [ "$?" = 1 ]; then
	kdialog --sorry "YOU CHOSE CANCEL";
else
	kdialog --error "ERROR";
fi;
#создание директорий в выбранной через kdialog папке
#konsole -e mkdir $dir_1'/textures' $dir_1'/models' $dir_1'/other'
mkdir $dir_1'/textures' $dir_1'/models' $dir_1'/other'
exit 0
