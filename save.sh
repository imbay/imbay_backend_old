/bin/bash <<EOF
    while true
    do
  	clear
  	git rm -r --cached .
  	git reset
  	git add --all
  	git commit -m "dev"
  	git push origin dev
  	sleep 59
    done
EOF
