# Backup Single MySQL Database + Notification Telegram

Before you started: <br />
1. You need to install MySQL client to your server. <br />
2. You need to install Telegram Send to your server. <br />
   Please see this reference to install Telegram Send: https://github.com/rahiel/telegram-send/ <br />
3. You need to create a Telegram Bot. <br />
   Please see this reference to create Telegram Bot: https://core.telegram.org/bots <br />
4. Change this parameters at backup-script.sh to your own. <br />
   HOST='(your-database-server-ip)' <br />
   DBNAME='(your-database-name)' <br />
   DSTFOLDER='(your-destination-folder)' <br />
   EXTRAFILE='(your-extra-file)' <br />
   LOG='(your-log-file)' <br />
5. Change this parameters at /etc/telegram-send.conf to your own. <br />
   token = (your-telegram-token) <br />
   chat_id = (your-group-chat-id) <br />
6. Change this parameters at .my.cnf to your own. <br />
   user="(your-database-user)" <br />
   password="(your-database-password)" <br />

How to run: <br />
/bin/sh backup-script.sh
