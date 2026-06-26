#!/usr/local/bin/bash

SCRIPT='src/main/bash/strings/not_empty.sh'

echo "Running test for \"${SCRIPT}\"..."

if [[ -L "${SCRIPT}" ]]; then
 echo "\"${SCRIPT}\" is a symlink!" >&2; exit 1
elif [[ ! -e "${SCRIPT}" ]]; then
 echo "\"${SCRIPT}\" does not exist!" >&2; exit 1
elif [[ ! -f "${SCRIPT}" ]]; then
 echo "\"${SCRIPT}\" is not a file!" >&2; exit 1
elif [[ ! -s "${SCRIPT}" ]]; then
 echo "\"${SCRIPT}\" is empty!" >&2; exit 1
elif [[ ! -x "${SCRIPT}" ]]; then
 echo "\"${SCRIPT}\" is not executable!" >&2; exit 1
elif ! /usr/local/bin/bash -n "${SCRIPT}"; then
 echo "\"${SCRIPT}\" has invalid syntax!" >&2; exit 1
fi

STDERR="$(mktemp)"

"${SCRIPT}" 2>"${STDERR}"; CODE=$?
if [[ "${CODE}" != '1' ]]; then
 echo "Code(${CODE}) error!" >&2; exit 1; fi
ACTUAL_VALUE="$(<"${STDERR}")"
if [[ "${ACTUAL_VALUE}" != 'Wrong arguments!' ]]; then
 echo "Actual value(${#ACTUAL_VALUE}) is: \"${ACTUAL_VALUE}\"!" >&2; exit 1; fi

:> "${STDERR}"

"${SCRIPT}" '' 2>"${STDERR}"; CODE=$?
if [[ "${CODE}" != '1' ]]; then
 echo "Code(${CODE}) error!" >&2; exit 1; fi
ACTUAL_VALUE="$(<"${STDERR}")"
if [[ "${ACTUAL_VALUE}" != 'Wrong arguments!' ]]; then
 echo "Actual value(${#ACTUAL_VALUE}) is: \"${ACTUAL_VALUE}\"!" >&2; exit 1; fi

:> "${STDERR}"

"${SCRIPT}" '' '' '' 2>"${STDERR}"; CODE=$?
if [[ "${CODE}" != '1' ]]; then
 echo "Code(${CODE}) error!" >&2; exit 1; fi
ACTUAL_VALUE="$(<"${STDERR}")"
if [[ "${ACTUAL_VALUE}" != 'Wrong arguments!' ]]; then
 echo "Actual value(${#ACTUAL_VALUE}) is: \"${ACTUAL_VALUE}\"!" >&2; exit 1; fi

:> "${STDERR}"

"${SCRIPT}" '' '' 2>"${STDERR}"; CODE=$?
if [[ "${CODE}" != '1' ]]; then
 echo "Code(${CODE}) error!" >&2; exit 1; fi
ACTUAL_VALUE="$(<"${STDERR}")"
if [[ "${ACTUAL_VALUE}" != 'No context!' ]]; then
 echo "Actual value(${#ACTUAL_VALUE}) is: \"${ACTUAL_VALUE}\"!" >&2; exit 1; fi

:> "${STDERR}"

"${SCRIPT}" '42' '' 2>"${STDERR}"; CODE=$?
if [[ "${CODE}" != '1' ]]; then
 echo "Code(${CODE}) error!" >&2; exit 1; fi
ACTUAL_VALUE="$(<"${STDERR}")"
EXPECTED_VALUE="Context: \"42\"
Value is empty!"
if [[ "${ACTUAL_VALUE}" != "${EXPECTED_VALUE}" ]]; then
 echo "Actual value(${#ACTUAL_VALUE}) is: \"${ACTUAL_VALUE}\"!" >&2; exit 1; fi

ACTUAL_TEXTS=(
 'a' ' ' $'\t' $'\n' $'\r' $'\v' $'\f' $'\x01'
 '!' '"' '#' '$' '%' '&' "'" '(' ')' '*' '+' ',' '-' '.' '/'
 ':' ';' '<' '=' '>' '?' '@' '[' ']' '^' '_' '`' '{' '|' '}' '~' '\'
)
for ACTUAL_TEXT in "${ACTUAL_TEXTS[@]}"; do
 :> "${STDERR}"
 "${SCRIPT}" '42' "${ACTUAL_TEXT}" 2>"${STDERR}"; CODE=$?
 if [[ "${CODE}" != '0' ]]; then
  echo "Code(${CODE}) error!" >&2; exit 1; fi
 ACTUAL_VALUE="$(<"${STDERR}")"
 if [[ -n "${ACTUAL_VALUE}" ]]; then
  echo "Actual value(${#ACTUAL_VALUE}) is: \"${ACTUAL_VALUE}\"!" >&2; exit 1; fi
done

rm "${STDERR}"
