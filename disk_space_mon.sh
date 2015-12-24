#!/bin/bash
# AUTHOR:   Tomas Nevar (tomas@lisenet.com)
# NAME:     disk_space_mon.sh
# VERSION:  1.0
# DATE:     06/08/2015 (dd/mm/yy)
# LICENCE:  Copyleft free software
#
THRESHOLD="80";
HOST="$(hostname --long)";
MAIL_FROM="disk_space_monitor@"$HOST"";
MAIL_TO="root@localhost";
DIR_ARRAY=(/ /home /var)

# Check if mailx is found on the system
if ! type mailx >/dev/null 2>&1; then
  echo "I need mailx, but it's not installed. This is sad.";
  exit 1;
fi

for dir in ${DIR_ARRAY[@]};do
  VALUE=$(df "$dir"|tail -n1|awk '{ print $5}'|sed 's/%//g');
  if [ "$VALUE" -gt "$THRESHOLD" ]; then
    AVAIL=$((100-$THRESHOLD));
    echo ""$dir" partition has less than "$AVAIL"% of free space. Used: "$VALUE"%"|\
      mailx -s "ALERT: Low disk space on $(hostname)" -r "$MAIL_FROM" "$MAIL_TO";
  fi
done
exit 0;
