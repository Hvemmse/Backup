#!/bin/bash

## Written by Frank Simens backup.sh Works in Arch and Ubuntu

# set date in format 11122022095407 aka daymonthyearhoursecond
ddate=$(date +"%d%m%Y%H%M%S")
# set path of rsync
which rsync > /tmp/path
path=$(cat /tmp/path)

# if rsync cannot be used install it.
if ! [[ -x $path ]]
then
   # if Arch do this
   #sudo pacman -Sy rsync
   # if ubuntu, Deian do this
   # sudo apt install rsync -y
   # if alpine linux do this
   # sudo apk add rsync

# Find us
case "$OST TYPE" in
   solaris*) echo "SOLARIS - not supported" ;;
   linux*) sudo pacman -Sy rsync ;;
   ubuntu*) sudo apt install rsync ;;
   *) echo "unknown: $OSTYPE" ;;
esac
fi

currentdir=$(pwd)
#define source
source="/boot /etc /home"
echo Source folders are $source
echo Target folder is current dir $currentdir
#define exclude
# edit exclude.txt
# eexclude="/home/frank/Fetched /home/$USER/.config /home/$USER/.cache"
echo Wait for 10 seconds. Use CTRL + c to Cancel
sleep 10
#create folder with ddate value
mkdir "$ddate"
#script folder for ddate
cd "$ddate"
# create a folder called current
mkdir current
#change to the folder current
cd current
# create these folders in the current folder 'tip' change here if you need others
# eg you can use other folders here or use a copy commando.
# an option is a use
# cp -ri ~/Music .
# or other
# rsync -r --progress ~/Music . | tee rsynclog
for i in $source
do
     rsync -r --exclude-from='../../exclude.txt' --progress /${i} . | tee rsynclog
done

# for value in Documents Music Pictures Miscellaneous Programming
# do
# mkdir $value
# done
