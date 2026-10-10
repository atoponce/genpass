genpass-graph() {
  # Usage: genpass-graph [NUM]
  #
  # Generate a password made from all graphical ASCII characters with a security margin of at
  # least 128 bits.
  #
  # Example password: xEmK>78(@O<M;}vSeQ(U
  #
  # If given a numerical argument, generate that many passwords.

  emulate -L zsh -o no_unset -o warn_create_global -o warn_nested_var
  zmodload zsh/mathfunc zsh/system

  # Test if argument is numeric, or return unsuccessfully
  if [[ ARGC -gt 1 || ${1-1} != ${~:-<1-$((16#7FFFFFFF))>} ]]; then
    print -ru2 -- "usage: $0 [NUM]"
    return 1
  fi

  local c
  local -r chars=({'!'..'~'}) # 94 graphical ascii characters
  local -r min=$((256 % $#chars))
  local -r length=$(( ceil(128/log2($#chars)) ))

  {
    repeat ${1-1}; do
      repeat $length; do
        while true; do
          sysread -s1 c || return
          (( #c >= min )) && break # Avoid bias towards smaller numbers.
        done
        print -rn -- $chars[#c%$#chars+1]
      done
      print
    done
  } < /dev/urandom
}
