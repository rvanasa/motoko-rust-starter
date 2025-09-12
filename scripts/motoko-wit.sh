#!/bin/bash

ROOT_DIR=$(dirname "$(realpath $0)")/../

cd $ROOT_DIR || exit

# Experimental API version
echo ... prepare witpkg structure... &&
mkdir -p target/witpkg/deps/component:meet-and-greet && # TODO: generalise for all components
cp src/rust/meet_and_greet/meet_and_greet.wit target/witpkg/deps/component:meet-and-greet/meet_and_greet.wit &&
cp target/motoko.wit target/witpkg/motoko.wit &&
echo ... running embed... &&
wasm-tools component embed target/witpkg target/motoko.wasm -o target/motoko-embed.wasm &&
echo ... creating component... &&
wasm-tools component new target/motoko-embed.wasm -v -o target/motoko-component.wasm --adapt wasi_snapshot_preview1=target/wasi-adapter.wasm &&
echo --- Composing components... &&
wac compose target/motoko.wac -d motoko:component=target/motoko-component.wasm --deps-dir mops/ -o target/motoko-composed.wasm &&
echo --- Composing done!
