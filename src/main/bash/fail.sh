#!/usr/local/bin/bash

if [[ $# -ne 1 ]]; then
 echo 'Wrong arguments!' >&2; exit 1; fi

ASSERTS_MESSAGE="$1"

if [[ -z "${ASSERTS_MESSAGE}" ]]; then
 echo 'No message!' >&2; exit 1; fi

echo "${ASSERTS_MESSAGE}" >&2

exit 1
