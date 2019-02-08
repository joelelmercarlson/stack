#!/usr/bin/env bash
#
# backup.sh -- sync your documents to your homedir
#
set -euo pipefail

# backup environment
NAS="//loki@nas/Homedirs/loki"
SRC="$HOME/Documents"
DEST="/Volumes/${USER}-1"
DIRS="docx pptx pdf vsd xlsx" 

env|sort

sleep 2

# mount
if [ ! -f $DEST/backup.sh ]
then
    mount -t smbfs $NAS $DEST
fi

if [ ! -d $SRC ]
then
    echo "$0: no $SRC"
    exit 1
fi

if [ ! -d $DEST ]
then
    echo "$0: no $DEST"
    exit 1
fi


# enforce permissions
cd $SRC
find $DIRS -type f -exec chmod 0700 {} \;

# sync
for i in $DIRS
do
    DESTX="$DEST/$i"
    mkdir -p $DESTX
    rsync -av --progress --delete-after $i/ $DESTX
done
