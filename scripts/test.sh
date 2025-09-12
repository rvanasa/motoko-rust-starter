#!/bin/bash
set -e

CURRENT_DIR=$(pwd)

./scripts/build_rust.sh

# Use provided directory or default to ../motoko
MOTOKO_DIR="${1:-../motoko}"
cd "$MOTOKO_DIR"

nix develop --command bash -c "
  make -C src moc && make -C rts &&
  cd $CURRENT_DIR &&
  ./scripts/build_motoko.sh &&
  wasmtime run target/motoko-composed.wasm"
