#!/bin/bash
export TARGET=wasm32-unknown-unknown
(
    cd "$(dirname "$0")/.." &&

    # Build Rust component
    cargo build --target $TARGET &&
    wasm-tools component new target/$TARGET/debug/component.wasm -o target/rust-component.wasm &&

    # Download `wasi_snapshot_preview1` adapter (used for building the Motoko component)
    ( wget -nc -q https://github.com/bytecodealliance/wasmtime/releases/download/v22.0.0/wasi_snapshot_preview1.command.wasm -O target/wasi-adapter.wasm || rm target/wasi-adapter.wasm ) &&

    # Build Motoko component
    # TODO: replace with `$(dfx cache show)/moc`
    nix-shell ../motoko/shell.nix --run "../motoko/bin/moc -wasi-system-api -import-component src/motoko/Main.mo -o target/motoko.wasm" &&
    wasm-tools component embed src/wit/motoko.wit target/motoko.wasm -o target/motoko-embed.wasm &&
    wasm-tools component new --skip-validation target/motoko-embed.wasm -o target/motoko-component.wasm --adapt wasi_snapshot_preview1=target/wasi-adapter.wasm &&
    
    # Compose components
    wac encode src/wac/composition.wac -d motoko:component=target/motoko-component.wasm -d rust:component=target/rust-component.wasm -o target/motoko-composed.wasm
)
