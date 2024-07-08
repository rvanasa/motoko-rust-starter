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

### Motoko Compiler

Since cross-language support relies on [this PR](https://github.com/dfinity/motoko/pull/4580), it's currently necessary to use a custom version of the Motoko compiler. You can set this up with the following steps:

```sh
# Open a terminal in the root of this repository
cd ..
git clone https://github.com/dfinity/motoko.git
cd motoko
git checkout ryan/component-call
```

We can remove this step after merging the corresponding PR.

### Scripts

The starter project includes Bash files in the `/scripts` directory to create and run a Motoko + Rust component.

**Build the component:**

```sh
scripts/build.sh
```

**Build and run in Wasmtime:**

```sh
scripts/run.sh
```
