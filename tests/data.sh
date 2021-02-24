#!/usr/bin/env bash

function processed_config() {
   cat <<EOT
Workspaces // Move to next //  <tab>  ## bindsym blob exec blob
Outputs // Focus change //  <alt> ← → ↑ ↓  ## bindcode worf exec worf worf
EOT
}

function default_config() {
   cat > "$CONFIG" <<EOT
## Workspaces // Move to next //  <tab>  ##
bindsym blob exec blob
## Outputs // Focus change //  <alt> ← → ↑ ↓  ##
bindcode worf exec worf worf
EOT
}

function default_parsed_xxd() {
   # Result of parsed default config xxd'ed
   cat <<EOT
00000000: 3c62 3e4d 6f76 6520 746f 206e 6578 7420  <b>Move to next 
00000010: 3c2f 623e 3c73 7061 6e20 666f 7265 6772  </b><span foregr
00000020: 6f75 6e64 3d22 6772 6579 223e 576f 726b  ound="grey">Work
00000030: 7370 6163 6573 203c 2f73 7061 6e3e 093c  spaces </span>.<
00000040: 7474 3e26 2378 4631 3741 3b20 266c 743b  tt>&#xF17A; &lt;
00000050: 7461 6226 6774 3b20 203c 2f74 743e 0069  tab&gt;  </tt>.i
00000060: 6e66 6f1f 6578 6563 2062 6c6f 621f 6d65  nfo.exec blob.me
00000070: 7461 1f62 6c6f 6220 6578 6563 2062 6c6f  ta.blob exec blo
00000080: 620a 3c62 3e46 6f63 7573 2063 6861 6e67  b.<b>Focus chang
00000090: 6520 3c2f 623e 3c73 7061 6e20 666f 7265  e </b><span fore
000000a0: 6772 6f75 6e64 3d22 6772 6579 223e 4f75  ground="grey">Ou
000000b0: 7470 7574 7320 3c2f 7370 616e 3e09 3c74  tputs </span>.<t
000000c0: 743e 2623 7846 3137 413b 2026 6c74 3b61  t>&#xF17A; &lt;a
000000d0: 6c74 2667 743b 2026 2378 3231 3930 3b20  lt&gt; &#x2190; 
000000e0: 2623 7832 3139 323b 2026 2378 3231 3931  &#x2192; &#x2191
000000f0: 3b20 2623 7832 3139 333b 2020 3c2f 7474  ; &#x2193;  </tt
00000100: 3e00 696e 666f 1f65 7865 6320 776f 7266  >.info.exec worf
00000110: 2077 6f72 661f 6d65 7461 1f77 6f72 6620   worf.meta.worf 
00000120: 6578 6563 2077 6f72 6620 776f 7266 0a    exec worf worf.
EOT
}

function main_result_xxd() {
   cat << EOT
00000000: 006d 6172 6b75 702d 726f 7773 1f74 7275  .markup-rows.tru
00000010: 650a 0a3c 623e 466f 6375 7320 6368 616e  e..<b>Focus chan
00000020: 6765 203c 2f62 3e3c 7370 616e 2066 6f72  ge </b><span for
00000030: 6567 726f 756e 643d 2267 7265 7922 3e4f  eground="grey">O
00000040: 7574 7075 7473 203c 2f73 7061 6e3e 2020  utputs </span>  
00000050: 2020 203c 7474 3e26 2378 4631 3741 3b20     <tt>&#xF17A; 
00000060: 266c 743b 616c 7426 6774 3b20 2623 7832  &lt;alt&gt; &#x2
00000070: 3139 303b 2026 2378 3231 3932 3b20 2623  190; &#x2192; &#
00000080: 7832 3139 313b 2026 2378 3231 3933 3b20  x2191; &#x2193; 
00000090: 203c 2f74 743e 696e 666f 1f65 7865 6320   </tt>info.exec 
000000a0: 776f 7266 2077 6f72 661f 6d65 7461 1f77  worf worf.meta.w
000000b0: 6f72 6620 6578 6563 2077 6f72 6620 776f  orf exec worf wo
000000c0: 7266 0a3c 623e 4d6f 7665 2074 6f20 6e65  rf.<b>Move to ne
000000d0: 7874 203c 2f62 3e3c 7370 616e 2066 6f72  xt </b><span for
000000e0: 6567 726f 756e 643d 2267 7265 7922 3e57  eground="grey">W
000000f0: 6f72 6b73 7061 6365 7320 3c2f 7370 616e  orkspaces </span
00000100: 3e20 203c 7474 3e26 2378 4631 3741 3b20  >  <tt>&#xF17A; 
00000110: 266c 743b 7461 6226 6774 3b20 203c 2f74  &lt;tab&gt;  </t
00000120: 743e 696e 666f 1f65 7865 6320 626c 6f62  t>info.exec blob
00000130: 1f6d 6574 611f 626c 6f62 2065 7865 6320  .meta.blob exec 
00000140: 626c 6f62 0a                             blob.
EOT
}
