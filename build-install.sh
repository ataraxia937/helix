#!/bin/sh
set -eu

# Updating rust version: edit rust-toolchain.toml
# Updating deps: `cargo update -p <dep>`
# Running tests: `cargo test --workspace --release`

# Skipping grammar builds: `-e  HELIX_DISABLE_AUTO_GRAMMAR_BUILD=1`
# Build them manually afterward and move them from /root/.config/helix/runtime/grammars to ./runtime/grammars

podman run --rm \
	-e HELIX_DEFAULT_RUNTIME=/usr/local/lib/helix/runtime \
	-v ./:/work -w /work \
	rust:latest \
	cargo build --locked --release --package helix-term
sudo rm -rf /usr/local/lib/helix
sudo install -o toolbox -g toolbox -m 755 target/release/hx /usr/local/bin/hx
sudo install -o toolbox -g toolbox -m 644 contrib/completion/hx.bash /usr/local/share/bash-completion/completions/hx
sudo rsync -aiP --exclude=grammars/sources runtime /usr/local/lib/helix/
sudo chown -R toolbox:toolbox /usr/local/lib/helix
