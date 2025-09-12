#!/bin/zsh
set -e

CURRENT_DIR=$(pwd)

# Use provided directory or default to ../motoko
MOTOKO_DIR="${1:-../motoko}"

# Navigate to motoko directory
cd "$MOTOKO_DIR"

# Build moc
nix develop --command bash -c "
  make -C src moc &&
  make -C rts
"

# Switch to nix develop shell where `moc` is available in the PATH
exec nix develop

# Execute manually after that:
# cd ../motoko-rust-starter
# make -C ../motoko/src moc && make -C ../motoko/rts
# wasmtime run target/motoko-composed.wasm
