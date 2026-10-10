genpass-csv() {
  # Usage: genpass-csv [NUM]
  #
  # Generate a password made of two 11-character alphanumeric strings, quoted, and comma-
  # separated with a security margin of at least 128 bits.
  #
  # > "Add commas to your passwords to mess with the CSV file they will be dumped into after being
  # > breached. Until next time!" ~ Skeletor
  #
  # Example password: "9Q8v6p3aCUm","qXYtKI8oKtc"
  #
  # If given a numerical argument, generate that many passwords.

  emulate -L zsh -o no_unset -o warn_create_global -o warn_nested_var
  zmodload zsh/mathfunc zsh/system

  # Test if argument is numeric, or return unsuccessfully
  if [[ ARGC -gt 1 || ${1-1} != ${~:-<1-$((16#7FFFFFFF))>} ]]; then
    print -ru2 -- "usage: $0 [NUM]"
    return 1
  fi

  {
    local c
    local -r chars="ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/" # Base 64
    local -r length=$(( ceil(128/log2($#chars)) ))

    repeat ${1-1}; do
      local pw=""
      repeat $length; do
        sysread -s1 c || return
        pw+=$chars[#c%$#chars+1] # Uniform as $#chars divides 256 evenly.
      done
      print -r -- "\"$pw[1,$#pw/2]\",\"$pw[$#pw/2+1,$#pw]\""
    done

  } < /dev/urandom
}
