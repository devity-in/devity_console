#!/bin/bash

# scripts/generate_dart_defines.sh

case "$1" in
"development") INPUT="env/development.env"
;;
"staging") INPUT="env/staging.env"
;;
"production") INPUT="env/production.env"
;;
*)
  echo "Missing arguments [development|staging|production]"
  exit 1
;;
esac

while IFS= read -r line
do
  DART_DEFINES="$DART_DEFINES--dart-define=$line "
done < "$INPUT"
echo "$DART_DEFINES"