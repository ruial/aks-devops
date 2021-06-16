#!/bin/sh
docker build -t goproject goproject
docker run -p 4001:4000 -e VAR1=123 goproject 4000
