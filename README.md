# Motoko + Rust Starter

[![Open in Gitpod](https://gitpod.io/button/open-in-gitpod.svg)](https://gitpod.io/#https://github.com/rvanasa/motoko-rust-starter)

> Note: running in-browser currently takes a while due to building the Motoko compiler from source.

## 📦 Overview

This repository is a minimal starter project for calling Rust functions from a Motoko program using the [WebAssembly Component Model](https://component-model.bytecodealliance.org/). While this is currently intended to be used with [Wasmtime](https://github.com/bytecodealliance/wasmtime#readme), it's possible to run the generated Motoko + Rust component in any environment with component model support. 

It's currently possible to call a function with a `Blob` input and return value, which can be used to pass arbitrary Candid-encoded values. 

## ⚙️ Getting Started

### System Requirements

* Unix operating system (tested on Ubuntu and macOS)
* [Rust](https://www.rust-lang.org/)
* [Wasmtime](https://github.com/bytecodealliance/wasmtime#readme)
* [`wasm-tools`](https://github.com/bytecodealliance/wasm-tools#readme)
* [`wac`](https://github.com/bytecodealliance/wac#readme)

### Motoko Compiler and Libraries

Since cross-language support relies on [this unmerged PR](https://github.com/dfinity/motoko/pull/5334), it's currently
necessary to use a custom version of the Motoko compiler. You can set this up with the following steps:

```sh
# Open a terminal in the root of this repository
cd ..
git clone https://github.com/dfinity/motoko.git
cd motoko
git checkout bartosz/components-mvp
nix develop
make -C src moc
make -C rts
```
Moreover, to compile the example Motoko application that imports components,
we need Motoko's core library.  Set it up as follows

```sh
# Open a terminal in the root of this repository
cd ..
git clone git@github.com:dfinity/motoko-core.git
```

When the setup is done, your GitHub-folder should have three repos at the same level:

- `github/motoko-rust-starter/`  (i.e. this repo)
- `github/motoko/` (Motoko compiler at branch bartosz/components-mvp)
- `github/motoko-core/` (Motoko core library)

### 📜 Scripts

The starter project includes Bash files in the `/scripts` directory to create and run a Motoko + Rust component.

**Building the imported Rust components**

Rust components are pre-built in `/mops/components/`-folder, but one
can use `build_rust.sh` to re-build the components if needed.

NOTE: This script may fail when run in Motoko's development nix-shell.
If this happens, run it in a separate shell with your regular Rust development setup.

```sh
./scripts/build_rust.sh
```
`build_rust.sh` first builds the components, and then copies the relevant files
to `mops/components/` as "distribution".  The layout of the distributed components
is somewhat weird (and needs improvements), as it tries to accommodate for conventions/limitations imposed
by the relevant tooling, see comments in [`build_rust.sh`](./scripts/build_rust.sh) for details.

**Build the Motoko component and the composed WASM binary**

This script should be run in Motoko's development nix-shell,
with moc-compiler built using PR https://github.com/dfinity/motoko/pull/5334"

```sh
./scripts/build_motoko.sh
```
When the modified `moc`-compiler is run by the above script, it generates on-the-fly two files:
- `target/motoko.wit`, needed for generating the Motoko-component binary `target/motoko-component.wasm`,
- `target/motoko.wac`, needed for generating the composed final binary `target/motoko-composed.wasm`,
   that can be run on `wasmtime`

The generation of these WASM-files happens subsequently in the script, using `wasm-tools` and `wac`-binaries.

**Build Motoko and run in Wasmtime:**

```sh
./scripts/run.sh
```

**Current main limitations/known issues, roughly in the order of priorities**

- compiling a Motoko source that uses components requires setting `MOC_UNLOCK_PRIM` env variable.
- supports only a subset of basic types as arguments or return values, see [Main.mo](./src/motoko/Main.mo) for details
- the expected layout of the distributed components (cf. [mops/component/](./mops/component/))
  is somewhat weird (and should be changed), due to various conventions wrt. underscore- and hyphen-characters,
  see comments in [build_rust.sh](./scripts/build_rust.sh) for more info
- the generated Motoko binaries use hard-coded motoko-string in their names; instead the binaries's names should
  probably depend on the name of the Motoko sources.
