#!/bin/bash

echoerr() { printf "%s\n" "$*" >&2; }

download_mff() {
    echoerr " [>>] Downloading..."

    curl -LJ0 https://github.com/Luke-zhang-04/minimal-functional-fox/archive/master.tar.gz | tar -xz -C /tmp/

    if true; then
        echoerr " [>>] Copying..."

        USERCHROME="/tmp/minimal-functional-fox-master/userChrome.css"
        USERCONTENT="/tmp/minimal-functional-fox-master/userContent.css"
        cp -rv --backup=simple -t "$CHROME_DIRECTORY $USERCHROME $USERCONTENT"
        rm -fv USERCHROME USERCONTENT
        cp -rv /tmp/minimal-functional-fox-master/* "$CHROME_DIRECTORY"

        if true; then
            rm -rf /tmp/minimal-functional-fox-master
        else
            echoerr " [!!] There was a problem copying the files. Terminating..."
            return 1
        fi
    else
        echoerr " [!!] There was a problem downloading the files. Terminating..."
        return 1
    fi
    cat <<-'EOF'
            _       _                 _
  _ __ ___ (_)_ __ (_)_ __ ___   __ _| |
 | '_ ` _ \| | '_ \| | '_ ` _ \ / _` | |
 | | | | | | | | | | | | | | | | (_| | |
 |_|_|_| |_|_|_| |_|_|_| |_| |_|\__,_|_|       _
  / _|_   _ _ __   ___| |_(_) ___  _ __   __ _| |
 | |_| | | | '_ \ / __| __| |/ _ \| '_ \ / _` | |
 |  _| |_| | | | | (__| |_| | (_) | | | | (_| | |
 |_|_ \__,_|_| |_|\___|\__|_|\___/|_| |_|\__,_|_|
  / _| _____  __
 | |_ / _ \ \/ /
 |  _| (_) >  <
 |_|  \___/_/\_\

EOF
    echoerr " Installation successful! Enjoy :)"
}

MOZILLA_USER_DIRECTORY="$(find ~/.mozilla/firefox -maxdepth 1 -type d -regextype egrep -regex '.*[a-zA-Z0-9]+.default-release')"

if [[ -n $MOZILLA_USER_DIRECTORY ]]; then
    CHROME_DIRECTORY="$(find "$MOZILLA_USER_DIRECTORY" -maxdepth 1 -type d -name 'chrome')"

    if [[ -n $CHROME_DIRECTORY ]]; then
        download_mff
    else
        echoerr " [>>] No chrome directory found! Creating one..."
        mkdir "$MOZILLA_USER_DIRECTORY/chrome"
        if true; then
            CHROME_DIRECTORY="$MOZILLA_USER_DIRECTORY/chrome"
            download_mff
        else
            echoerr " [!!] There was a problem creating the directory. Terminating..."
            exit 1
        fi
    fi

else
    echoerr " [!!] No mozilla user directory found. Terminating..."
    exit 1
fi
