#!/bin/bash

user=$1
password=$2
userPivpn=$(sudo cat /etc/pivpn/openvpn/setupVars.conf | grep install_user | sed s/install_user=//)

#if echo "$password" | su -c "echo" "$user" >/dev/null 2>&1; then
if echo "$password" | su -c "echo" "$user" >/dev/null 2>&1 && [ "$user" == "$userPivpn" ]; then
    echo "Authenticated"
else
    echo "Not Authenticated"
fi
