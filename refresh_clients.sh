#!/usr/bin/env bash
set -euo pipefail

# Path to the wfn executable; override with the WFN_PATH env var
WFN="${WFN_PATH:-wfn}"

# Check wfn exists
if ! command -v "$WFN" >/dev/null 2>&1; then
  echo "Error: '$WFN' WebFunction CLI tool was not found in your PATH." >&2
  echo "You can specify its location using the WFN_PATH environment variable, e.g.:" >&2
  echo "  WFN_PATH=/path/to/wfn $0" >&2
  echo "If you don't have the tool, get/build it from https://github.com/webfunction-protocol/webfunction-cli" >&2
  exit 1
fi

mkdir -p merchant terminal sdk

# Generate code for clients (each API is its own Go package)
"$WFN" codegen --target go --url https://api.reservepay.com/merchants -o ./merchant/merchant.go --namespace merchant
"$WFN" codegen --target go --url https://api.reservepay.com/terminals -o ./terminal/terminal.go --namespace terminal
"$WFN" codegen --target go --url https://api.reservepay.com/sdk -o ./sdk/sdk.go --namespace sdk

# Make sure go.mod / go.sum match what the generated clients import (needs go)
if command -v go >/dev/null 2>&1; then
  go mod tidy
  go build ./...
  echo "Clients generated, 'go mod tidy' run and 'go build ./...' passed"
else
  echo "Install 'go' and run 'go mod tidy' to finish setting up the module"
fi
