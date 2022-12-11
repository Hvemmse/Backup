#!/bin/bash

## Writen by Frank Simens backup.sh Works in Arch and Ubuntu

# sæt dato i format 11122022095407 aka dagmånedårtimersekund
ddato=$(date +"%d%m%Y%H%M%S")
# set path of rsync
which rsync > /tmp/path 
sti=$(cat /tmp/path)

# hvis rsync ikke kan bruges installer den.
if ! [[ -x $sti ]]
then
  # if Arch do this
  #sudo pacman -Sy rsync
  # if ubuntu,Deian do this
  # sudo apt install rsync -y
  # if alpine linux do this
  # sudo apk add rsync

# Find os
case "$OSTYPE" in
  solaris*) echo "SOLARIS - not supported" ;;
  linux*)   sudo pacman -Sy rsync ;;
  ubuntu*)  sudo apt install rsync ;;
  *)        echo "unknown: $OSTYPE" ;;
esac
fi

currentdir=$(pwd)
#define source
source="/boot /etc /home"
echo Source folders are $source
echo Target folder is current dir $currentdir
#define exclude
# edit exlude.txt
# eexclude="/home/frank/Hentet /home/$USER/.config /home/$USER/.cache"
echo Wait for 10 seconds. Use CTRL + c to Cancel
sleep 10
#opret mappe med ddato værdi
mkdir "$ddato"
#skrift mappe til ddato
cd "$ddato"
# opret en mappe der hedder current
mkdir current
#skift til mappen current
cd current
# opret disse mapper i current mappen 'tip' ændre her hvis du skal bruge andre
# eks. du kan bruge andre mapper her eller bruge en copy commando.
# en mulighed er et bruge
# cp -ri ~/Musik .
# eller andet
# rsync -r --progress ~/Musik . | tee rsynclog
for i in $source
do
    rsync -r --exclude-from='../../exclude.txt' --progress /${i} . | tee rsynclog
done

# for value in Dokumenter Musik Billeder Diverse Programmering
# do
# mkdir $value
# done
