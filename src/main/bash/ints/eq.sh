#!/usr/local/bin/bash

if [[ $# -ne 3 ]]; then
 echo 'Wrong arguments!' >&2; exit 1; fi

ASSERTS_CONTEXT="$1"

if [[ -z "${ASSERTS_CONTEXT}" ]]; then
 echo 'No context!' >&2; exit 1; fi

ASSERTS_ACTUAL="$2"

if [[ ! "${ASSERTS_ACTUAL}" =~ ^(0|-?[1-9][0-9]*)$ ]]; then
 echo "Actual(${#ASSERTS_ACTUAL}): \"${ASSERTS_ACTUAL}\" is not a number!" >&2; exit 1
elif ((ASSERTS_ACTUAL < -2147483648 || ASSERTS_ACTUAL > 2147483647)); then
 echo "Actual: ${ASSERTS_ACTUAL} is not an int64!" >&2; exit 1
fi

ASSERTS_EXPECTED="$3"

if [[ ! "${ASSERTS_EXPECTED}" =~ ^(0|-?[1-9][0-9]*)$ ]]; then
 echo "Expected(${#ASSERTS_EXPECTED}): \"${ASSERTS_EXPECTED}\" is not a number!" >&2; exit 1
elif ((ASSERTS_EXPECTED < -2147483648 || ASSERTS_EXPECTED > 2147483647)); then
 echo "Expected: ${ASSERTS_EXPECTED} is not an int64!" >&2; exit 1
fi

if [[ "${ASSERTS_ACTUAL}" -ne "${ASSERTS_EXPECTED}" ]]; then
 printf '%s' "Context: \"${ASSERTS_CONTEXT}\"
Actual: ${ASSERTS_ACTUAL}
Expected: ${ASSERTS_EXPECTED}
" >&2; exit 1; fi
