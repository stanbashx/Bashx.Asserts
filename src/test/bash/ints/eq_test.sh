#!/usr/local/bin/bash

SCRIPT='src/main/bash/ints/eq.sh'

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

STDOUT="$(mktemp)"
STDERR="$(mktemp)"

#

:> "${STDOUT}"
:> "${STDERR}"
"${SCRIPT}" > "${STDOUT}" 2> "${STDERR}"; CODE=$?
if [[ "${CODE}" != '1' ]]; then
 echo "Code(${CODE}) error!" >&2; exit 1; fi
if [[ -n "$(<"${STDOUT}")" ]]; then
 echo "Script \"${SCRIPT}\" has stdout!" >&2; exit 1; fi
ACTUAL_VALUE="$(<"${STDERR}")"
if [[ "${ACTUAL_VALUE}" != 'Wrong arguments!' ]]; then
 echo "Actual value(${#ACTUAL_VALUE}) is: \"${ACTUAL_VALUE}\"!" >&2; exit 1; fi

:> "${STDOUT}"
:> "${STDERR}"
"${SCRIPT}" '' '' > "${STDOUT}" 2> "${STDERR}"; CODE=$?
if [[ "${CODE}" != '1' ]]; then
 echo "Code(${CODE}) error!" >&2; exit 1; fi
if [[ -n "$(<"${STDOUT}")" ]]; then
 echo "Script \"${SCRIPT}\" has stdout!" >&2; exit 1; fi
ACTUAL_VALUE="$(<"${STDERR}")"
if [[ "${ACTUAL_VALUE}" != 'Wrong arguments!' ]]; then
 echo "Actual value(${#ACTUAL_VALUE}) is: \"${ACTUAL_VALUE}\"!" >&2; exit 1; fi

:> "${STDOUT}"
:> "${STDERR}"
"${SCRIPT}" '' '' '' '' > "${STDOUT}" 2> "${STDERR}"; CODE=$?
if [[ "${CODE}" != '1' ]]; then
 echo "Code(${CODE}) error!" >&2; exit 1; fi
if [[ -n "$(<"${STDOUT}")" ]]; then
 echo "Script \"${SCRIPT}\" has stdout!" >&2; exit 1; fi
ACTUAL_VALUE="$(<"${STDERR}")"
if [[ "${ACTUAL_VALUE}" != 'Wrong arguments!' ]]; then
 echo "Actual value(${#ACTUAL_VALUE}) is: \"${ACTUAL_VALUE}\"!" >&2; exit 1; fi

#

echo 'Not implemented!'; exit 1 # todo

#

rm "${STDOUT}"
rm "${STDERR}"
