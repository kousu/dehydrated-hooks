#!/bin/sh

run_parts() {
  # a replacement for run-parts(8)
  # that supports passing arguments
  # (run-parts supports this but demands they are passed individually, which is not compatible with the "$@" special-case for writing wrapper scripts)
  # usage: run-parts DIRECTORY [arg... ]

  # TODO: support --verbose; requires getting getopts out I guess.

  dir="$1"; shift
  if [ -d "$dir" ]; then
    ls -1 "${dir}" 2>/dev/null | while read prog; do
      if [ -x "$prog" ]; then
        "${prog}" "$@"
      fi
    done
  fi
}

operation="$1"; shift
case "${operation}" in
  clean_challenge|deploy_challenge|deploy_cert)
    "${operation}" "$@"
    ;;
esac

run_parts "${BASEDIR}"/hooks/"${operation}".d/ "$@"
