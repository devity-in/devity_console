#!/bin/bash

# run.sh

if [ -z "$1" ] || [ -z "$2" ]; then
  echo -e "Missing arguments: [release|debug|profile] [development|staging|production]"
  # invalid arguments
  exit 128
fi

DART_DEFINES=$(scripts/generate_dart_defines.sh "$2")

# shellcheck disable=SC2181
if [ $? -ne 0 ]; then
  echo -e "Failed to generate dart defines"
  exit 1
fi

echo -e "type: $2, flavor: $3\n"
echo -e "DART_DEFINES: $DART_DEFINES\n"

eval "flutter run --$1 --target lib/main_$2.dart --flavor $2 $DART_DEFINES"