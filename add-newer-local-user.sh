#!/bin/bash

if [[ $UID -ne 0 ]]
then
  echo "You don't have a superuser privileges. Please, run again sudo ${0}" >&2
  exit 1
fi

if [[ $# -lt 1 ]]
then
  echo "You did not provided any arguments: USERNAME and REALNAME" >&2
  exit 1
fi

USERNAME=$1
COMMENT_FOR_ACC=$@
PASSWORD=$(echo "${RANDOM}$(date +%s%N)${RANDOM}" | sha256sum | head -c10)

useradd -c "${COMMENT_FOR_ACC}" -m $USERNAME &> /dev/null

if [[ $? -ne 0 ]]
then
  echo "Creation of account for user ${USERNAME} is failed." >&2
  exit 1
fi

echo $PASSWORD | passwd --stdin $USERNAME &> /dev/null
passwd -e $USERNAME &> /dev/null

echo "Account is created successfully:"
echo
echo "Username: ${USERNAME}"
echo
echo "Password: ${PASSWORD}"
echo
echo "Hostname: ${HOSTNAME}"
exit 0


