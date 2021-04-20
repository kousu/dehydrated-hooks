#!/bin/sh

run_parts() {
  # a replacement for run-parts(8)
  # that supports passing arguments
  # (run-parts supports this but demands they are passed individually, which is not compatible with the "$@" special-case for writing wrapper scripts)
  # usage: run-parts DIRECTORY [arg... ]

  # TODO: support --verbose; requires getting getopts out I guess.

  dir="$1"; shift
  if [ -d "$dir" ]; then
    ls -1 "${dir}" | sort | while read prog; do
      if [ -x "${dir}/${prog}" ]; then
        echo "Running ${dir}/${prog}"
        "${dir}/${prog}" "$@"
      fi
    done
  fi
}

operation="$1"; shift
(
  cd "${BASEDIR}"/hooks/ # pretty-print the script that's running by only passing the relevant subpath to run_parts
  run_parts "${operation}".d/ "$@"
)
