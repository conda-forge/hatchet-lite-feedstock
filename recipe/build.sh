#!bin/bash

set -euxo pipefail

pushd src/frontend/app
pnpm install --frozen-lockfile
pnpm store prune
npm run docs:gen
npm run build
mkdir -p $PREFIX/share/hatchet
mv dist $PREFIX/share/hatchet/static-assets
mkdir -p $PREFIX/etc/conda/env_vars.d
echo "{\"LITE_STATIC_ASSET_DIR\": \"$PREFIX/share/hatchet/static-assets\"}" > $PREFIX/etc/conda/env_vars.d/hatchet-lite.json

pushd $SRC_DIR/src/cmd/hatchet-lite
go-licenses save . --save_path "$SRC_DIR/library_licenses" --ignore github.com/mattn/go-localereader
go build -v -o $PREFIX/bin/hatchet-lite -ldflags="-s -w -X 'main.Version=${PKG_VERSION}'"
