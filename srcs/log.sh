#!/usr/bin/env bash

RED=$'\e[0;31m'
YELLOW=$'\e[0;33m'
RESET=$'\e[0m'

log_info() {
  printf '%b|INFO%b %s %b]%b\n' "$YELLOW" "$RESET" "$1" "$YELLOW" "$RESET";
}

log_error()  {
  printf '%b|ERROR%b %s %b]%b\n' "$RED" "$RESET" "$1" "$YELLOW" "$RESET" >&2;
}
