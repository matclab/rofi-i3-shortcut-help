#!/usr/bin/env bash

set -eo pipefail

: "${XDG_CACHE_HOME:="$HOME"/.cache}"
: "${CACHE_FILE:="$XDG_CACHE_HOME/rofi-shortcut"}"
: "${XDG_CONFIG_HOME:="$HOME"/.config}"
: "${CONFIG:="$XDG_CONFIG_HOME/i3/config"}"


function parse {
   if [[ $CACHE_FILE -nt $CONFIG ]]
   then
      cat "$CACHE_FILE"
   else
      while read -r line
      do
	 help=$(echo "$line" | xmlstarlet esc | \
	    sed -e 's!\(.*\)\/\/ *\(.*\)\/\/ *\(.*\)##.*!<b>\2</b><span foreground="grey">\1</span>\t<tt>\3</tt>!')
	 command=$(echo "$line" | sed -e 's/.*##.*bind[^ ]* *[^ ]* *\(.*\)/\1/' -e 's/--release//')
	 meta=$(echo "$line" | sed -e 's/.*##.*bind[^ ]* \(.*\)/\1/' | xmlstarlet esc)
	 printf "%s\0info\x1f%s\x1fmeta\x1f%s\n" "$help" "$command" "$meta" 
      done | tee "$CACHE_FILE"
   fi
}

: "${_PARSE:=parse}"  # for integratin testing
: "${_I3MSG:=i3-msg}"  # for integratin testing

function main()
{
   echo -e "\0markup-rows\x1ftrue\n"
   if [[ $ROFI_RETV == 0 ]]
   then
      # initial call
      grep -A1 '^ *##[^#]' "$CONFIG"  |
	 grep -v '^--' | # remove -- separator added by grep
	 sed '$!N;s/\n/ /' | # join lines two by two
	 sed -e 's/^ *## *//'| # remove front marker ##
	 "$_PARSE" | sort -k2 -t"	" |
	 tr "\0" "\v" | column -t -s $'\t' | tr "\v" "\0"
  elif  [[ -n  "$ROFI_INFO" ]]
   then
      # ROFI_INFO contains the i3 command
      exec "$_I3MSG" "$ROFI_INFO" >/dev/null 2>&1
   fi
}

main
