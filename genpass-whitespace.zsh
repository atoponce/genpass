genpass-whitespace() {
  # Usage: genpass-whitespace [NUM]
  #
  # Generate a password made of 32 non-control, non-graphical, horizontal spaces/blanks with a
  # security margin of at least 128 bits.
  #
  # Both nonzero- and zero-width characters are used. Two characters are technically vertical
  # characters, but aren't interpreted as such in the shell. They are "\u2028" and "\u2029". You
  # might need a font with good Unicode support to prevent some of these characters creating tofu.
  #
  # The password is wrapped in braille pattern blanks for correctly handling zero-width characters
  # at the edges, to prevent whitespace stripping by the auth form, and to guarantee a copy-able
  # width should only zero-width characters be generated.
  #
  # Requires a font with good Unicode coverage. Noto Sans Mono is a solid choice. Tested in the
  # following terminal emulators:
  #
  # 100% blank:
  # - alacritty
  # - foot
  # - gnome-console
  # - gnome-terminal
  # - lxterminal
  # - mate-terminal
  # - sakura
  # - st
  # - terminator
  # - termit
  # - uxterm
  # - xfce-terminal
  # - xterm
  #
  # Prints tofu:
  # - kitty
  # - qterminal
  # - rxvt-unicode
  #
  # Example password: "⠀ㅤ	            ㅤ⠀　⠀"
  #
  # If given a numerical argument, generate that many passwords.

  zmodload zsh/mathfunc zsh/system
  emulate -L zsh -o no_unset -o warn_create_global -o warn_nested_var

  local -i i

  # Test if argument is numeric, or return unsuccessfully
  if [[ ARGC -gt 1 || ${1-1} != ${~:-<1-$((16#7FFFFFFF))>} ]]; then
    print -ru2 -- "usage: $0 [NUM]"
    return 1
  fi

  # clear all existing tab stops, then set one at every column
  print -n '\e[3g'
  for (( i = 1; i < COLUMNS; i++ )); do print -n ' \eH'; done
  print -n '\r'

  {
    local c
    local -r chars=(
      # https://gist.github.com/atoponce/ebbed45d66b1d8a6dc557520d88cadce
      $'\u0009' $'\u001C' $'\u001D' $'\u001E' $'\u001F' $'\u0020' $'\u0089' $'\u00A0'
      $'\u2000' $'\u2001' $'\u2002' $'\u2003' $'\u2004' $'\u2005' $'\u2006' $'\u2007'
      $'\u2008' $'\u2009' $'\u200A' $'\u200B' $'\u2028' $'\u2029' $'\u202F' $'\u205F'
      $'\u2062' $'\u2063' $'\u2064' $'\u2800' $'\u3000' $'\u3164' $'\uFEFF' $'\uFFA0'
    )
    local -r length=$(( ceil(128/log2($#chars)) ))

    repeat ${1-1}; do
      local pw=""

      pw+=$'"\u2800'

      repeat $length; do
        sysread -s1 c || return
        local x=$chars[#c%$#chars+1]
        pw+="$x"
      done

      pw+=$'\u2800"'

      print -rP -- "$pw"
    done
  } < /dev/urandom

  # clear previous tab stops, restore default 8-column stops
  print -n '\e[3g'
  for (( i = 9; i <= COLUMNS; i += 8 )); do print -n "\e[${i}G\eH"; done
  print -n '\r'
}
