#!/usr/bin/env bats
#set -x
load bats-support/load
load bats-assert/load
load bats-mock/load
load data.sh


function setup() {
   mkdir -p "${BATS_TMPDIR:?/tmp}/$BATS_TEST_NAME"
   cd "$BATS_TMPDIR/$BATS_TEST_NAME" || \
      fail "unable to cd in $BATS_TMPDIR/BTNBATS_TEST_NAME"
   export CACHEDIR="/tmp/$BATS_TEST_NAME.cache"
   mkdir -p "$CACHEDIR"
   export CACHE_FILE="$CACHEDIR/ris"
}
function teardown() {
   [[ -d $CACHEDIR ]] && rm -rf "$CACHEDIR"
   [[ -d "${BATS_TMPDIR:?/tmp}/$BATS_TEST_NAME" ]] && \
      rm -rf "${BATS_TMPDIR:?/tmp}/$BATS_TEST_NAME"
}

SRC="$BATS_TEST_DIRNAME/.."


load "$SRC/shortcut.sh"

function parse_xxd(){
   # Convert output to hex dump
   processed_config | parse | xxd
}


@test 'parse works as expected' {
# Run parse function and feed it with preprocessed config
   CONFIG="/tmp/ris-config"

   run parse_xxd
   
   default_parsed_xxd | assert_output -
}

@test 'parse use cache if more recent' {
   CONFIG="/tmp/ris-config"
   echo "CACHE CONTENT" > "$CACHE_FILE"

   run parse

   assert_output - <<< "CACHE CONTENT"
}

@test "parse don't use cache if older" {
# Run parse function and feed it with preprocessed config
   CONFIG="/tmp/ris-config"
   echo "CACHE CONTENT" > "$CACHE_FILE"
   touch "$CONFIG"

   run parse_xxd

   refute_line --partial "CACHE CONTENT"
}

