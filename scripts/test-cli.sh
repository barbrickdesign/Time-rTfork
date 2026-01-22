#!/bin/bash

# =================================================================
#
# Work of the U.S. Department of Defense, Defense Digital Service.
# Released as open source under the MIT License.  See LICENSE file.
#
# =================================================================

# Script to run CLI tests using shunit2
# Usage: ./scripts/test-cli.sh

set -euo pipefail

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Function to print error messages
error() {
  echo "ERROR: $*" >&2
  exit 1
}

# Verify the now binary exists
if [[ ! -f "${DIR}/../bin/now" ]]; then
  error "Binary '${DIR}/../bin/now' not found. Run 'make bin/now' to build it."
fi

# Verify shunit2 exists
if [[ ! -f "${DIR}/shunit2" ]]; then
  error "shunit2 not found at ${DIR}/shunit2"
fi

testEpochSeconds() {
  "${DIR}/../bin/now" -e -p s
}

testEpochMilliseconds() {
  "${DIR}/../bin/now" -e -p ms
}

testEpochMicroseconds() {
  "${DIR}/../bin/now" -e -ps us
}

testEpochNanoseconds() {
  "${DIR}/../bin/now" -e -p ns
}

testKitchen() {
  "${DIR}/../bin/now" -f Kitchen
}

testRFC3339Nano() {
  "${DIR}/../bin/now" -f RFC3339Nano
}

testRFC3339() {
  "${DIR}/../bin/now" -f RFC3339
}

testYearMonthDay() {
  "${DIR}/../bin/now" -f 2006-01-02
}

testTimeZoneFixed() {
  "${DIR}/../bin/now" -z UTC+09:30
}

testTimeZoneNamed() {
  "${DIR}/../bin/now" -z America/New_York
}

oneTimeSetUp() {
  echo "Using temporary directory at ${SHUNIT_TMPDIR}"
  echo "Testing now binary: ${DIR}/../bin/now"
}

oneTimeTearDown() {
  echo "All CLI tests completed"
}

# Load shUnit2.
# shellcheck disable=SC1091
. "${DIR}/shunit2"
