# Motoko + Rust Starter

## Overview

This repository provides a minimal starter project for calling Rust functions from a Motoko program using the [WebAssembly Component Model](https://component-model.bytecodealliance.org/). While this is currently intended to be used with [Wasmtime](https://github.com/bytecodealliance/wasmtime#readme), it's possible to run the generated Motoko + Rust component in any environment with component model support. 

## Getting Started

### System Requirements

* Unix operating system (tested on Ubuntu and macOS)
* [Rust](https://www.rust-lang.org/)
* [Wasmtime](https://github.com/bytecodealliance/wasmtime#readme)
* [`wasm-tools`](https://github.com/bytecodealliance/wasm-tools#readme)
* [`wac`](https://github.com/bytecodealliance/wac#readme)
* [`dfx`](https://support.dfinity.org/hc/en-us/articles/10552713577364-How-do-I-install-dfx)

### Scripts

This repository includes Bash scripts which document how to build and combine a Motoko + Rust component.

#### Build the component:

```sh
scripts/build.sh
```

#### Run in Wasmtime:

```sh
scripts/run.sh
```
