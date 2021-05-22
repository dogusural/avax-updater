#!/bin/bash

AVALANCHE_FOLDER="$GOPATH/src/github.com/ava-labs/gecko"

cd "$AVALANCHE_FOLDER" || exit 1

git fetch origin
reslog=$(git log HEAD..origin/master --oneline)
if [[ "${reslog}" != "" ]] || [[ $1 = "force" ]] ; then
  git merge origin/master # completing the pull
  if [ $? -eq 0 ]; then
    bash -c "$AVALANCHE_FOLDER/scripts/build.sh"

    if [ $? -eq 0 ]; then
        sudo systemctl restart avalanche.service
    else
        echo "scipts/build.sh returned a non-zero code. Exiting..."
        exit 1
    fi

  else
    echo "git pull failed. Exiting..."
    exit 1
  fi
else
    echo "Already up to date"
    exit 0
fi
