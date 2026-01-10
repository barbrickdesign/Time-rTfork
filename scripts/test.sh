#!/bin/bash

# =================================================================
#
# Work of the U.S. Department of Defense, Defense Digital Service.
# Released as open source under the MIT License.  See LICENSE file.
#
# =================================================================

# Script to run Go tests and static analysis tools
# Usage: ./scripts/test.sh

set -euo pipefail

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Function to print error messages
error() {
  echo "ERROR: $*" >&2
  exit 1
}

# Function to print section headers
print_section() {
  echo "******************"
  echo "$1"
  echo "******************"
}

# move up a directory
cd "$DIR/.."

# Verify required tools exist
for tool in bin/shadow bin/errcheck bin/ineffassign bin/staticcheck; do
  if [[ ! -f "$tool" ]]; then
    error "Required tool '$tool' not found. Run 'make test_go' to build dependencies."
  fi
done

# Get list of packages, excluding vendor
pkgs=$(go list ./... | grep -v /vendor/ | tr "\n" " ")

if [[ -z "$pkgs" ]]; then
  error "No Go packages found"
fi

print_section "Running unit tests"
# shellcheck disable=SC2086
go test -p 1 -count 1 -short $pkgs

print_section "Running go vet"
# shellcheck disable=SC2086
go vet $pkgs

print_section "Running go vet with shadow"
# shellcheck disable=SC2086
go vet -vettool="bin/shadow" $pkgs

print_section "Running errcheck"
# shellcheck disable=SC2086
bin/errcheck $pkgs

print_section "Running ineffassign"
find . -name '*.go' -print0 | xargs -0 bin/ineffassign

print_section "Running staticcheck"
# shellcheck disable=SC2086
bin/staticcheck -checks all $pkgs

echo "******************"
echo "All tests passed!"
echo "******************"
