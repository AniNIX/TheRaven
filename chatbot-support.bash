#!/bin/bash
url="$(wget -q -O - http://alice.pandorabots.com/ | grep iframe | cut -f 2 -d \")"
curl -s --data "input=$(echo $1 | sed "s/$2//g" | sed 's/^: //')" "$url" | grep 'ALICE:' | tail -n 1 | cut -f 3 -d '>' | sed 's/  ALICE:  //' | sed "s/ALICE/$2/g" | sed "s/Alice/$2/g" | sed "s/  om/ friend/"
