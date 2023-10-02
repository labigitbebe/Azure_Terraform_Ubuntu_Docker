cat << EOF >> /Users/gokhany/.ssh/config

Host ${hostname}
    hostname ${hostname}
    user ${user}
    identityfile ${identityfile}
EOF