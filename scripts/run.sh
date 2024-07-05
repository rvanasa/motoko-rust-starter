#!/bin/bash
(
    cd "$(dirname "$0")/.." &&
    scripts/build.sh &&
    wasmtime run target/motoko-composed.wasm
)
