#!/usr/local/bin/bash

if [[ $# -ne 1 ]]; then
 echo 'Wrong arguments!' >&2; exit 1; fi

ASSERTS_MESSAGE="$1"

echo "${ASSERTS_MESSAGE}" >&2

exit 1
