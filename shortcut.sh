#!/bin/bash

CACHE="$HOME/.cache/rofi-shortcut"
CONFIG="$HOME/.config/i3/config"

echo -e "\0markup-rows\x1ftrue\n"

function parse {
   if [[ $CACHE -nt $CONFIG ]]
   then
      cat "$CACHE"
   else
      while read -r line
      do
	 help=$(echo "$line" | xml esc | \
	    sed -e 's!\(.*\)\/\/ *\(.*\)\/\/ *\(.*\)##.*!<b>\2</b><span foreground="grey">\1</span>\t<tt>\3</tt>!')
	 command=$(echo "$line" | sed -e 's/.*##.*bind[^ ]* *[^ ]* *\(.*\)/\1/')
	 meta=$(echo "$line" | sed -e 's/.*##.*bind[^ ]* \(.*\)/\1/' | xml esc)
	 printf "%s\0info\x1f%s\x1fmeta\x1f%s\n" "$help" "$command" "$meta" 
      done | tee "$CACHE"
   fi
}

if [[ $ROFI_RETV == 0 ]]
then
   # initial call
   rg -N -A1 '^ *##' "$CONFIG"  \
      | rg -v '^--'| sed '$!N;s/\n/ /' | sed -e 's/^ *## *//'| parse \
      | sort -k2 -t"	" \
      | tr "\0" "\v" | column -t -s $'\t' | tr "\v" "\0"
else 
   # ROFI_INFO contains the i3 command
   exec i3-msg "$ROFI_INFO" >/dev/null 2>&1
fi
