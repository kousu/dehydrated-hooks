#!/bin/sh

if [ -z "${HOOK:-}" ]; then 
  echo "hooks.sh: \$HOOK already defined: ${HOOK}. Please uninstall the conflicting dehydrated plugin to use dehydrated-hooks." >&2
  exit 1
fi

HOOK="${BASEDIR}"/hooks/hooks.sh
