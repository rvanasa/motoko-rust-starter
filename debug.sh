#!/bin/bash

# USAGE:
# 1. ./scripts/test.sh to compile and run the successful version (this generates files in target/)
# 2. ./debug.sh 0 to save the dump of the successful version
# 3. Change the code, e.g. uncomment failing tests in Main.mo
# 4. ./scripts/test.sh to compile and run the failing version
# 5. ./debug.sh 1 to save the dump of the failing version
# 6. ./debug.sh (without argument) to perform a diff between the two versions
# 7. Inspect the .diff and .txt files in the target/ directory

# Read Input: Version 0 or 1 or diff
VERSION=$1

if [ "$VERSION" -eq 0 ]; then
  echo "Version 0"
elif [ "$VERSION" -eq 1 ]; then
  echo "Version 1"
else
  echo "Performing diff between versions 0 and 1"
  for wasm_file in target/*.wasm; do
    if [ -f "$wasm_file" ]; then
      # Expects two files: $wasm_file.0.txt and $wasm_file.1.txt
      # Perform git diff --no-index $wasm_file.0.txt $wasm_file.1.txt
      git diff --no-index "$wasm_file.0.txt" "$wasm_file.1.txt" > "$wasm_file.diff"
    fi
  done
  git diff --no-index target/motoko.wit.0.txt target/motoko.wit.1.txt > target/motoko.wit.diff
  exit 0
fi

for wasm_file in target/*.wasm; do
  if [ -f "$wasm_file" ]; then
    echo "=== wasm-tools print $wasm_file ==="
    wasm-tools print "$wasm_file" > "$wasm_file.$VERSION.txt"
    echo ""
  fi
done

cat target/motoko.wit > "target/motoko.wit.$VERSION.txt"



