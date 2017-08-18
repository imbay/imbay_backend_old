/bin/bash <<EOF
    while true
    do
    clear
    git add --all
    git commit -m "dev"
    git push origin dev --force
    sleep 59
    done
EOF
