#!/usr/local/bin/bash

if [[ $# -ne 2 ]]; then
 echo 'Wrong arguments!' >&2; exit 1; fi

ASSERTS_PATH="$1"

if [[ -z "${ASSERTS_PATH}" ]]; then
 echo 'No path!' >&2; exit 1
elif [[ -L "${ASSERTS_PATH}" ]]; then
 echo "\"${ASSERTS_PATH}\" is a symlink!" >&2; exit 1
elif [[ ! -e "${ASSERTS_PATH}" ]]; then
 echo "\"${ASSERTS_PATH}\" does not exist!" >&2; exit 1
elif [[ ! -f "${ASSERTS_PATH}" ]]; then
 echo "\"${ASSERTS_PATH}\" is not a file!" >&2; exit 1
elif [[ ! -s "${ASSERTS_PATH}" ]]; then
 echo "\"${ASSERTS_PATH}\" is empty!" >&2; exit 1
fi

ASSERTS_EXPECTED="$2"

if [[ -z "${ASSERTS_EXPECTED}" ]]; then
 echo 'No expected!' >&2; exit 1; fi

printf '%s' "${ASSERTS_EXPECTED}" | cmp -s - "${ASSERTS_PATH}"; CODE=$?
if [[ "${CODE}" == '1' ]]; then
 printf '%s' "\"${ASSERTS_PATH}\"
does not equal:
---(${#ASSERTS_EXPECTED})
${ASSERTS_EXPECTED}
---" >&2; exit 1
elif [[ "${CODE}" != '0' ]]; then
 echo 'Read file error!' >&2; exit 1
fi
