#!/bin/bash

dirname="$(kdialog \
  --inputbox "Folder to be created" "./Textures" \
  )" &&

mkdir -p -- "$dirname"


exit 0
