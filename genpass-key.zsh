genpass-key() {
  # Usage: genpass-key [NUM]
  #
  # Generate a hexadecimal key with a security margin of at least 128 bits.
  #
  # Example password: 15227fc6ac9337d5d30e1370c3ebe883
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
  local -r chars=abcdef0123456789

  {
    repeat ${1-1}; do
      repeat 32; do
        sysread -s1 c || return
        # This is uniform because $#chars divides 256.
        print -rn -- $chars[#c%$#chars+1]
      done
      print
    done
  } < /dev/urandom
}
