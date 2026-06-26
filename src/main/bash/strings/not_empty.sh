#!/usr/local/bin/bash

if [[ $# -ne 2 ]]; then
 echo 'Wrong arguments!' >&2; exit 1; fi

ASSERTS_CONTEXT="$1"

if [[ -z "${ASSERTS_CONTEXT}" ]]; then
 echo 'No context!' >&2; exit 1; fi

ASSERTS_TEXT="$2"

if [[ -z "${ASSERTS_TEXT}" ]]; then
 printf '%s' "Context: \"${ASSERTS_CONTEXT}\"
Value is empty!
" >&2; exit 1; fi
