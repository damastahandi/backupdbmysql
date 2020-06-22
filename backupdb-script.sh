#!/bin/sh
HOST='(your-database-server-ip)'
DBNAME='(your-database-name)'
DSTFOLDER='(your-destination-folder)'
EXTRAFILE='(your-extra-file)'
DATE="$(date '+%d%m%Y-%H%M')"
LOG='(your-log-file)'

# Create an alias
alias cddstfolder='cd $DSTFOLDER'

# Backup database
/usr/bin/mysqldump --defaults-extra-file=$EXTRAFILE -h $HOST --single-transaction --routines $DBNAME > $DSTFOLDER/$DBNAME.sql 2> $LOG
if [ "$?" -ne 0 ]
then
 /usr/local/bin/telegram-send -g "Backup database error, please see $LOG for detail information."
else
 # Go to destination folder
 cddstfolder
 # Compress database
 /usr/bin/tar -zcf $DBNAME-$DATE.tar.gz -C $DSTFOLDER $DBNAME.sql 2> $LOG
 if [ "$?" -ne 0 ]
 then
  /usr/local/bin/telegram-send -g "Compressing file backup has failed, please see $LOG for detail information."
 else
  # Remove file with extension .sql
  /usr/bin/rm -f $DSTFOLDER/$DBNAME.sql
  # Backup & compress successful, send notification to telegram
  LISTFILES="$(ls -lhtr $DSTFOLDER | awk '{print $5,$9}')"
  /usr/local/bin/telegram-send -g "Backup database $DBNAME has successful! $LISTFILES"
  # Remove file after 7 days
  find $DSTFOLDER -maxdepth 1 -type f -mtime +7 -name '*.tar.gz'
  if [ "$?" -ne 0 ]
  then
   /usr/local/bin/telegram-send -g "Backup file older than 7 days not found." 
  else
   DELETEFILES="$(find $DSTFOLDER -maxdepth 1 -type f -mtime +7 -name '*.tar.gz' -ls -exec rm {} \;)"
   /usr/local/bin/telegram-send -g "Backup file older than 7 days has been deleted! $DELETEFILES"
  fi
 fi
fi
