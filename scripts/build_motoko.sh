#!/bin/bash
source "$(dirname "$0")/set_env.sh"
export MOC_UNLOCK_PRIM=true

# echo "INFO: $0 should be run in Motoko's development nix-shell,"
# echo "      with moc-compiler built using PR https://github.com/dfinity/motoko/pull/5334"

ROOT_DIR=$(dirname "$(realpath $0)")/..
MO_SRC_DIR="src/motoko"
MOC_BIN="$ROOT_DIR/../motoko/bin/moc"
MOC_PACKAGES=$(cd $ROOT_DIR/$MO_SRC_DIR || exit; mops sources | sed "s|.mops|$MO_SRC_DIR/.mops|g")
MOC_COMPONENT_PACKAGES=""
for folder in $ROOT_DIR/mops/component/*@*; do
  package_with_version=$(basename -- "$folder")
  package="${package_with_version%@*}"
  echo Component: $package_with_version $package
  MOC_COMPONENT_PACKAGES="$MOC_COMPONENT_PACKAGES --package $package $ROOT_DIR/mops/component/$package_with_version"
done

cd $ROOT_DIR || exit

# Create target directory if it doesn't exist
mkdir -p target

if [ -f target/wasi-adapter.wasm  ]; then
  echo "--- WASI adapter wasi_snapshot_preview1 is present at target/wasi-adapter.wasm, skipping download"
else
  echo "--- Downloading WASI adapter wasi_snapshot_preview1 to target/wasi-adapter.wasm ..."
  ( curl -L https://github.com/bytecodealliance/wasmtime/releases/download/v22.0.1/wasi_snapshot_preview1.command.wasm -o target/wasi-adapter.wasm )
fi &&
echo --- Building Motoko component... &&
echo ... running moc... &&
$MOC_BIN $MO_SRC_DIR/Main.mo -wasi-system-api -wasm-components --legacy-persistence $MOC_PACKAGES $MOC_COMPONENT_PACKAGES -o target/motoko.wasm &&
echo ... running embed... &&
wasm-tools component embed target/motoko.wit target/motoko.wasm -o target/motoko-embed.wasm &&
echo ... creating component... &&
wasm-tools component new target/motoko-embed.wasm -v -o target/motoko-component.wasm --adapt wasi_snapshot_preview1=target/wasi-adapter.wasm &&
echo --- Composing components... &&
wac compose target/motoko.wac -d motoko:component=target/motoko-component.wasm --deps-dir mops/ -o target/motoko-composed.wasm &&
echo --- Composing done, output written to target/motoko-composed.wasm

