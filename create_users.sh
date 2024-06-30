#!/bin/bash
# Script to create users and groups from a given input file.

#Log file
LOG_FILE="/var/log/user_management.log"
#Password file
PASSWORD_FILE="/var/secure/user_passwords.csv"

if [ -z "$1" ]; then
    echo "Usage: $0 <user_groups_file>"
    exit 1
fi

USER_GROUPS_FILE="$1"

mkdir -p /var/secure
chmod 700 /var/secure

> "$LOG_FILE"
> "$PASSWORD_FILE"

log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$LOG_FILE"
}
generate_password() {
    tr -dc A-Za-z0-9 </dev/urandom | head -c 12
}

while IFS=';' read -r username groups; do
    username=$(echo "$username" | xargs) # trim whitespaces
    groups=$(echo "$groups" | xargs)     # trim whitespaces
if id "$username" &>/dev/null; then
    log "User $username already exists. Skipping."
    continue
fi

user_group="$username"
if ! getent group "$user_group" &>/dev/null; then
    groupadd "$user_group"
    log "Group $user_group created."
fi

useradd -m -g "$user_group" -s /bin/bash "$username"
log "User $username created with group $user_group."

if [ -n "$groups" ]; then
    IFS=',' read -ra ADDR <<< "$groups"
    for group in "${ADDR[@]}"; do
        group=$(echo "$group" | xargs) # trim whitespaces
        if ! getent group "$group" &>/dev/null; then
            groupadd "$group"
            log "Group $group created."
        fi
        usermod -aG "$group" "$username"
        log "User $username added to group $group."
    done
fi

password=$(generate_password)
echo "$username:$password" | chpasswd
log "Password set for user $username."
echo "$username,$password" >> "$PASSWORD_FILE"
done < "$USER_GROUPS_FILE"

chmod 600 "$PASSWORD_FILE"
chown root:root "$PASSWORD_FILE"

log "User creation process completed."
echo "User creation process completed. Check $LOG_FILE for details."

