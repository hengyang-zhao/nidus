#!/usr/bin/env bash

target="$1"

old_user_name=$(git config --get user.name 2>/dev/null)
if [ -z "$old_user_name" ]; then
    read -r -p "Please enter your git user name: " user_name
else
    read -r -p "Please enter your git user name [$old_user_name]: " user_name
fi
if [ -z "$user_name" ]; then
    user_name="$old_user_name"
fi

old_user_email=$(git config --get user.email 2>/dev/null)
if [ -z "$old_user_email" ]; then
    read -r -p "Please enter your git email: " user_email
else
    read -r -p "Please enter your git email [$old_user_email]: " user_email
fi
if [ -z "$user_email" ]; then
    user_email="$old_user_email"
fi

if [ -n "$target" ] && [ "$target" != "-" ]; then
    exec > $target
    if [ $? != 0 ]; then
        exit 1
    fi
fi

cat << EOF
# GENERATED BY NIDUS.
# IT IS OK TO MODIFY THIS FILE.
# THIS FILE IS NOT UNDER NIDUS VERSION CONTROL.

[user]
    name = $user_name
    email = $user_email

# vim: ft=gitconfig:
EOF



# vim: ft=sh:
