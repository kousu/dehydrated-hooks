#!/bin/sh

run-parts() {
  # a replacement for run-parts(8)
  # that supports passing arguments
  # (run-parts supports this but demands they are passed individually, which is not compatible with the "$@" special-case for writing wrapper scripts)
  # usage: run-parts DIRECTORY [arg... ]
  
  # TODO: support --verbose; requires getting getopts out I guess.
  
  dir="$1"; shift
  
  ls -1 "${dir}" | while read prog; do
    "${prog}" "$@"
  done
}

operation="$1"; shift
case "${operation}" in
  clean_challenge)
  deploy_challenge)
  deploy_cert)
    "${operation}" "$@"
    ;;
  *)
    echo "Unsupported operation '${operation}'" >&2
    exit 1;
    ;;
esac

run-parts "${BASEDIR}"/hooks/"${operation}".d/ "$@"
