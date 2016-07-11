#!/bin/bash

IFS=';' read -ra USERS <<< "$MAIL_USERS"
IFS=';' read -ra PASS <<< "$MAIL_PASSWORDS"

USERS_LENGTH=${#USERS[@]}
PASS_LENGTH=${#PASS[@]}

if [ "$USERS_LENGTH" -ne "$PASS_LENGTH" ]; then
  echo "You must have the same number of users and passwords.";
  exit -1;
fi

cd /tmp/docker-mailserver/

echo "==> Generating users"
touch postfix-accounts.cf
for i in "${!USERS[@]}"; do
  USER="${USERS[$i]}"
  PASS="${PASS[$i]}"

  if ! grep -q "$USER" "./postfix-accounts.cf"; then
    CRED="$USER|$(doveadm pw -s SHA512-CRYPT -u $USER -p $PASS)"

    echo "$CRED" >> postfix-accounts.cf
    echo "==> User: $USER generated"
  else
    echo "==> User: $USER already existing. Skip"
  fi
done

echo "==> Generating DKIM"
/usr/local/bin/generate-dkim-config
echo "==> DKIM generated"

echo "==========> Edit your DNS with this setting:"
cat "/tmp/docker-mailserver/opendkim/keys/$MAIL_DOMAIN/mail.txt"