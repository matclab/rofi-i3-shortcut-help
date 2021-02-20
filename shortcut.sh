#!/bin/bash

set -eo pipefail

: "${XDG_CACHE_HOME:="$HOME"/.cache}"
: "${CACHE_FILE:="$XDG_CACHE_HOME/rofi-shortcut"}"
: "${XDG_CONFIG_HOME:="$HOME"/.config}"
: "${CONFIG:="$XDG_CONFIG_HOME/i3/config"}"

echo -e "\0markup-rows\x1ftrue\n"

function parse {
   if [[ $CACHE_FILE -nt $CONFIG ]]
   then
      cat "$CACHE_FILE"
   else
      while read -r line
      do
	 help=$(echo "$line" | xml esc | \
	    sed -e 's!\(.*\)\/\/ *\(.*\)\/\/ *\(.*\)##.*!<b>\2</b><span foreground="grey">\1</span>\t<tt>\3</tt>!')
	 command=$(echo "$line" | sed -e 's/.*##.*bind[^ ]* *[^ ]* *\(.*\)/\1/')
	 meta=$(echo "$line" | sed -e 's/.*##.*bind[^ ]* \(.*\)/\1/' | xml esc)
	 printf "%s\0info\x1f%s\x1fmeta\x1f%s\n" "$help" "$command" "$meta" 
      done | tee "$CACHE_FILE"
   fi
}

if [[ $ROFI_RETV == 0 ]]
then
   # initial call
   grep -A1 '^ *##' "$CONFIG"  \
      | grep -v '^--'| sed '$!N;s/\n/ /' | sed -e 's/^ *## *//'| parse \
      | sort -k2 -t"	" \
      | tr "\0" "\v" | column -t -s $'\t' | tr "\v" "\0"
else 
   # ROFI_INFO contains the i3 command
   exec i3-msg "$ROFI_INFO" >/dev/null 2>&1
fi
