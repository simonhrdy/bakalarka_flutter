#!/bin/bash

current_dir=$PWD

cd $current_dir

echo -e "Initializing"

flutter pub get

dart run build_runner build --delete-conflicting-outputs
dart run phrase

flutter gen-l10n
wait
