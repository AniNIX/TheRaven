#!/bin/bash
lynx -connect_timeout=3 -read_timeout=3 --dump 'http://m.wolframalpha.com/input/?i='"$(echo $1 | sed 's/+/%2B/g' | tr ' ' '+')"'&x=0&y=0' | cat -n | egrep '^    21' | head -n 1 | xargs | cut -f 2 -d ' '
