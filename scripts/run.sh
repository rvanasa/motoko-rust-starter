#!/bin/bash
(
    cd "$(dirname "$0")/.." &&

    echo "NOTE: If you need to (re-)build Rust components, please run scripts/build_rust.sh separately,"
    echo "      in a shell with your regular Rust development environment."
    echo "      Building Rust does not work in Motoko's development nix-shell,"
    echo "      which is needed for scripts/build_motoko.sh"
    echo ""
    # scripts/build_rust.sh &&

    echo ... running scripts/build_motoko.sh ...
    scripts/build_motoko.sh &&
    
    echo ... running target/motoko-composed.wasm ...
    wasmtime run target/motoko-composed.wasm
)
