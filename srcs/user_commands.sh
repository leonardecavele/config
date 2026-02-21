if [[ "${bash_source[1]}" == "${0}" ]]; then
  log_error "${bash_source[1]}" "this script is not meant to be sourced nor executed"
  exit 1
fi

# cat -> pygmentize on each file argument
unalias cat 2>/dev/null
unset -f cat 2>/dev/null

cat() {
  if [ "$#" -eq 0 ]; then
    command cat
    return
  fi

  local f
  for f in "$@"; do
	printf '%b%b|%s|%b\n' "$RESET" "$CYAN" "$f" "$RESET"
    pygmentize -g "$f"
  done
}
