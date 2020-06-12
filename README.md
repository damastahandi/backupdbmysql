# Backup Single MySQL Database

Before you started:
1. You need to install MySQL client to your server.
2. You need to install Telegram Send to your server.
   Please see this reference to install Telegram Send: https://github.com/rahiel/telegram-send/
3. You need to create a Telegram Bot.
   Please see this reference to create Telegram Bot: https://core.telegram.org/bots
4. Change this parameters at backup-script.sh to your own.
   HOST='(your-database-server-ip)'
   DBNAME='(your-database-name)'
   DSTFOLDER='(your-destination-folder)'
   EXTRAFILE='(your-extra-file)'
   LOG='(your-log-file)'
5. Change this parameters at /etc/telegram-send.conf to your own.
   token = (your-telegram-token)
   chat_id = (your-group-chat-id)
6. Change this parameters at .my.cnf to your own.
   user="(your-database-user)"
   password="(your-database-password)"

How to run:
/bin/sh backup-script.sh
