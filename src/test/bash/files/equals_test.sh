#!/usr/local/bin/bash

SCRIPT='src/main/bash/files/equals.sh'

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

# arguments

:> "${STDOUT}"
:> "${STDERR}"
"${SCRIPT}" >"${STDOUT}" 2>"${STDERR}"; CODE=$?
if [[ "${CODE}" != '1' ]]; then
 echo "Code(${CODE}) error!" >&2; exit 1; fi
[[ -s "${STDOUT}" ]] && exit 1
ACTUAL_VALUE="$(<"${STDERR}")"
if [[ "${ACTUAL_VALUE}" != 'Wrong arguments!' ]]; then
 echo "Actual value(${#ACTUAL_VALUE}) is: \"${ACTUAL_VALUE}\"!" >&2; exit 1; fi

:> "${STDOUT}"
:> "${STDERR}"
"${SCRIPT}" '' >"${STDOUT}" 2>"${STDERR}"; CODE=$?
if [[ "${CODE}" != '1' ]]; then
 echo "Code(${CODE}) error!" >&2; exit 1; fi
[[ -s "${STDOUT}" ]] && exit 1
ACTUAL_VALUE="$(<"${STDERR}")"
if [[ "${ACTUAL_VALUE}" != 'Wrong arguments!' ]]; then
 echo "Actual value(${#ACTUAL_VALUE}) is: \"${ACTUAL_VALUE}\"!" >&2; exit 1; fi

:> "${STDOUT}"
:> "${STDERR}"
"${SCRIPT}" '' '' '' >"${STDOUT}" 2>"${STDERR}"; CODE=$?
if [[ "${CODE}" != '1' ]]; then
 echo "Code(${CODE}) error!" >&2; exit 1; fi
[[ -s "${STDOUT}" ]] && exit 1
ACTUAL_VALUE="$(<"${STDERR}")"
if [[ "${ACTUAL_VALUE}" != 'Wrong arguments!' ]]; then
 echo "Actual value(${#ACTUAL_VALUE}) is: \"${ACTUAL_VALUE}\"!" >&2; exit 1; fi

#

:> "${STDOUT}"
:> "${STDERR}"
"${SCRIPT}" '' '' >"${STDOUT}" 2>"${STDERR}"; CODE=$?
if [[ "${CODE}" != '1' ]]; then
 echo "Code(${CODE}) error!" >&2; exit 1; fi
[[ -s "${STDOUT}" ]] && exit 1
ACTUAL_VALUE="$(<"${STDERR}")"
if [[ "${ACTUAL_VALUE}" != 'No path!' ]]; then
 echo "Actual value(${#ACTUAL_VALUE}) is: \"${ACTUAL_VALUE}\"!" >&2; exit 1; fi

:> "${STDOUT}"
:> "${STDERR}"
TMP_PATH="$(mktemp)"
rm "${TMP_PATH}"
"${SCRIPT}" "${TMP_PATH}" '' >"${STDOUT}" 2>"${STDERR}"; CODE=$?
if [[ "${CODE}" != '1' ]]; then
 echo "Code(${CODE}) error!" >&2; exit 1; fi
[[ -s "${STDOUT}" ]] && exit 1
ACTUAL_VALUE="$(<"${STDERR}")"
if [[ "${ACTUAL_VALUE}" != "\"${TMP_PATH}\" does not exist!" ]]; then
 echo "Actual value(${#ACTUAL_VALUE}) is: \"${ACTUAL_VALUE}\"!" >&2; exit 1; fi

:> "${STDOUT}"
:> "${STDERR}"
TMP_PATH="$(mktemp -d)"
"${SCRIPT}" "${TMP_PATH}" '' >"${STDOUT}" 2>"${STDERR}"; CODE=$?
if [[ "${CODE}" != '1' ]]; then
 echo "Code(${CODE}) error!" >&2; exit 1; fi
[[ -s "${STDOUT}" ]] && exit 1
ACTUAL_VALUE="$(<"${STDERR}")"
if [[ "${ACTUAL_VALUE}" != "\"${TMP_PATH}\" is not a file!" ]]; then
 echo "Actual value(${#ACTUAL_VALUE}) is: \"${ACTUAL_VALUE}\"!" >&2; exit 1; fi
rm -rf "${TMP_PATH}"

:> "${STDOUT}"
:> "${STDERR}"
TMP_PATH="$(mktemp)"
rm "${TMP_PATH}"
ln -s "${TMP_PATH}" "${TMP_PATH}" && [[ -L "${TMP_PATH}" ]] || exit 1
"${SCRIPT}" "${TMP_PATH}" '' >"${STDOUT}" 2>"${STDERR}"; CODE=$?
if [[ "${CODE}" != '1' ]]; then
 echo "Code(${CODE}) error!" >&2; exit 1; fi
[[ -s "${STDOUT}" ]] && exit 1
ACTUAL_VALUE="$(<"${STDERR}")"
if [[ "${ACTUAL_VALUE}" != "\"${TMP_PATH}\" is a symlink!" ]]; then
 echo "Actual value(${#ACTUAL_VALUE}) is: \"${ACTUAL_VALUE}\"!" >&2; exit 1; fi
rm "${TMP_PATH}"

:> "${STDOUT}"
:> "${STDERR}"
TMP_PATH="$(mktemp)"
"${SCRIPT}" "${TMP_PATH}" '' >"${STDOUT}" 2>"${STDERR}"; CODE=$?
if [[ "${CODE}" != '1' ]]; then
 echo "Code(${CODE}) error!" >&2; exit 1; fi
[[ -s "${STDOUT}" ]] && exit 1
ACTUAL_VALUE="$(<"${STDERR}")"
if [[ "${ACTUAL_VALUE}" != "\"${TMP_PATH}\" is empty!" ]]; then
 echo "Actual value(${#ACTUAL_VALUE}) is: \"${ACTUAL_VALUE}\"!" >&2; exit 1; fi
rm "${TMP_PATH}"

:> "${STDOUT}"
:> "${STDERR}"
TMP_PATH="$(mktemp)"
printf '%s' 'foo' > "${TMP_PATH}"
"${SCRIPT}" "${TMP_PATH}" '' >"${STDOUT}" 2>"${STDERR}"; CODE=$?
if [[ "${CODE}" != '1' ]]; then
 echo "Code(${CODE}) error!" >&2; exit 1; fi
[[ -s "${STDOUT}" ]] && exit 1
ACTUAL_VALUE="$(<"${STDERR}")"
if [[ "${ACTUAL_VALUE}" != 'No text!' ]]; then
 echo "Actual value(${#ACTUAL_VALUE}) is: \"${ACTUAL_VALUE}\"!" >&2; exit 1; fi
rm "${TMP_PATH}"

#

:> "${STDOUT}"
:> "${STDERR}"
TMP_PATH="$(mktemp)"
printf '%s' 'foo' > "${TMP_PATH}"
ASSERTS_TEXTS=('42' 'foobar' 'barfoo' ' foo' 'foo ' $'\nfoo' $'\tfoo' $'foo\n' $'foo\t')
for ASSERTS_TEXT in "${ASSERTS_TEXTS[@]}"; do
 "${SCRIPT}" "${TMP_PATH}" "${ASSERTS_TEXT}" >"${STDOUT}" 2>"${STDERR}"; CODE=$?
 if [[ "${CODE}" != '1' ]]; then
  echo "Code(${CODE}) error!" >&2; exit 1; fi
 [[ -s "${STDOUT}" ]] && exit 1
 EXPECTED_VALUE="\"${TMP_PATH}\"
does not equal:
---(${#ASSERTS_TEXT})
${ASSERTS_TEXT}
---"
 ACTUAL_VALUE="$(<"${STDERR}")"
 if [[ "${ACTUAL_VALUE}" != "${EXPECTED_VALUE}" ]]; then
  echo "Actual value(${#ACTUAL_VALUE}) is: \"${ACTUAL_VALUE}\"!" >&2; exit 1; fi
done
rm "${TMP_PATH}"

:> "${STDOUT}"
:> "${STDERR}"
TMP_PATH="$(mktemp)"
printf '%s' $'foo\n' > "${TMP_PATH}"
ASSERTS_TEXTS=('42' 'foobar' 'barfoo' ' foo' 'foo ' $'\nfoo' $'\tfoo' $'foo\t')
for ASSERTS_TEXT in "${ASSERTS_TEXTS[@]}"; do
 "${SCRIPT}" "${TMP_PATH}" "${ASSERTS_TEXT}" >"${STDOUT}" 2>"${STDERR}"; CODE=$?
 if [[ "${CODE}" != '1' ]]; then
  echo "Code(${CODE}) error!" >&2; exit 1; fi
 [[ -s "${STDOUT}" ]] && exit 1
 EXPECTED_VALUE="\"${TMP_PATH}\"
does not equal:
---(${#ASSERTS_TEXT})
${ASSERTS_TEXT}
---"
 ACTUAL_VALUE="$(<"${STDERR}")"
 if [[ "${ACTUAL_VALUE}" != "${EXPECTED_VALUE}" ]]; then
  echo "Actual value(${#ACTUAL_VALUE}) is: \"${ACTUAL_VALUE}\"!" >&2; exit 1; fi
done
rm "${TMP_PATH}"

:> "${STDOUT}"
:> "${STDERR}"
TMP_PATH="$(mktemp)"
ASSERTS_TEXTS=('42' 'foobar' 'barfoo' ' foo' 'foo ' $'\nfoo' $'\tfoo' $'foo\n' $'foo\t')
for ASSERTS_TEXT in "${ASSERTS_TEXTS[@]}"; do
 printf '%s' "${ASSERTS_TEXT}" > "${TMP_PATH}"
 "${SCRIPT}" "${TMP_PATH}" "${ASSERTS_TEXT}" >"${STDOUT}" 2>"${STDERR}"; CODE=$?
 if [[ "${CODE}" != '0' ]]; then
  echo "Code(${CODE}) error!" >&2; exit 1; fi
 [[ -s "${STDOUT}" ]] && exit 1
 ACTUAL_VALUE="$(<"${STDERR}")"
 if [[ -n "${ACTUAL_VALUE}" ]]; then
  echo "Actual value(${#ACTUAL_VALUE}) is: \"${ACTUAL_VALUE}\"!" >&2; exit 1; fi
done
rm "${TMP_PATH}"

rm "${STDOUT}"
rm "${STDERR}"
