#!/usr/bin/env bats
#set -x
load bats-support/load
load bats-assert/load
load bats-mock/load


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

load data.sh

@test 'main preprocess as expected' {
   export CONFIG="/tmp/ris-config"
   default_config

   parse="$(mock_create)"
   mock_set_side_effect "$parse" "cat > /tmp/ris-parse-in"  # copy stdin to stdout
   mock_set_output "$parse" "blob"

   ROFI_RETV=0 _PARSE="$parse" run "$SRC/shortcut.sh"

   assert_equal "$(mock_get_call_num "$parse")" "1"

   diff <(cat "/tmp/ris-parse-in") <(processed_config)
}

function shortcut_xxd() {
   "$SRC/shortcut.sh" | xxd
}

@test 'main postprocess as expected' {
   export CONFIG="/tmp/ris-config"
   default_config

   parse="$(mock_create)"
   mock_set_output "$parse" "$(default_parsed_xxd | xxd -r)"

   ROFI_RETV=0 _PARSE="$parse" run shortcut_xxd

   assert_equal "$(mock_get_call_num "$parse")" "1"
   diff <(main_result_xxd) <(echo "$output")

}

@test 'launch selected command' {
   export CONFIG="/tmp/ris-config"
   default_config

   i3msg="$(mock_create)"

   ROFI_RETV=1 ROFI_INFO="blob truc" _I3MSG="$i3msg" run "$SRC/shortcut.sh"

   assert_equal "$(mock_get_call_num "$i3msg")" "1"
   assert_equal "$(mock_get_call_args "$i3msg")" "blob truc"

}
