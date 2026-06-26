#!/usr/local/bin/bash

SCRIPT='src/main/bash/files/contains.sh'

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
if [[ "${ACTUAL_VALUE}" != 'No path!' ]]; then
 echo "Actual value(${#ACTUAL_VALUE}) is: \"${ACTUAL_VALUE}\"!" >&2; exit 1; fi

:> "${STDERR}"
TMP_PATH="$(mktemp)"
rm "${TMP_PATH}"
"${SCRIPT}" "${TMP_PATH}" '' 2>"${STDERR}"; CODE=$?
if [[ "${CODE}" != '1' ]]; then
 echo "Code(${CODE}) error!" >&2; exit 1; fi
ACTUAL_VALUE="$(<"${STDERR}")"
if [[ "${ACTUAL_VALUE}" != "\"${TMP_PATH}\" does not exist!" ]]; then
 echo "Actual value(${#ACTUAL_VALUE}) is: \"${ACTUAL_VALUE}\"!" >&2; exit 1; fi

:> "${STDERR}"
TMP_PATH="$(mktemp -d)"
"${SCRIPT}" "${TMP_PATH}" '' 2>"${STDERR}"; CODE=$?
if [[ "${CODE}" != '1' ]]; then
 echo "Code(${CODE}) error!" >&2; exit 1; fi
ACTUAL_VALUE="$(<"${STDERR}")"
if [[ "${ACTUAL_VALUE}" != "\"${TMP_PATH}\" is not a file!" ]]; then
 echo "Actual value(${#ACTUAL_VALUE}) is: \"${ACTUAL_VALUE}\"!" >&2; exit 1; fi
rm -rf "${TMP_PATH}"

:> "${STDERR}"
TMP_PATH="$(mktemp)"
rm "${TMP_PATH}"
ln -s "${TMP_PATH}" "${TMP_PATH}" && [[ -L "${TMP_PATH}" ]] || exit 1
"${SCRIPT}" "${TMP_PATH}" '' 2>"${STDERR}"; CODE=$?
if [[ "${CODE}" != '1' ]]; then
 echo "Code(${CODE}) error!" >&2; exit 1; fi
ACTUAL_VALUE="$(<"${STDERR}")"
if [[ "${ACTUAL_VALUE}" != "\"${TMP_PATH}\" is a symlink!" ]]; then
 echo "Actual value(${#ACTUAL_VALUE}) is: \"${ACTUAL_VALUE}\"!" >&2; exit 1; fi
rm "${TMP_PATH}"

:> "${STDERR}"
TMP_PATH="$(mktemp)"
"${SCRIPT}" "${TMP_PATH}" '' 2>"${STDERR}"; CODE=$?
if [[ "${CODE}" != '1' ]]; then
 echo "Code(${CODE}) error!" >&2; exit 1; fi
ACTUAL_VALUE="$(<"${STDERR}")"
if [[ "${ACTUAL_VALUE}" != "\"${TMP_PATH}\" is empty!" ]]; then
 echo "Actual value(${#ACTUAL_VALUE}) is: \"${ACTUAL_VALUE}\"!" >&2; exit 1; fi
rm "${TMP_PATH}"

:> "${STDERR}"
TMP_PATH="$(mktemp)"
printf '%s' 'foo' > "${TMP_PATH}"
"${SCRIPT}" "${TMP_PATH}" '' 2>"${STDERR}"; CODE=$?
if [[ "${CODE}" != '1' ]]; then
 echo "Code(${CODE}) error!" >&2; exit 1; fi
ACTUAL_VALUE="$(<"${STDERR}")"
if [[ "${ACTUAL_VALUE}" != 'No subtext!' ]]; then
 echo "Actual value(${#ACTUAL_VALUE}) is: \"${ACTUAL_VALUE}\"!" >&2; exit 1; fi
rm "${TMP_PATH}"

ASSERTS_SUBTEXT='bar'

TMP_PATH="$(mktemp)"
printf '%s' 'foo' > "${TMP_PATH}"
EXIT_CODES=(2 42 127)
for MOCKS_RG_EXIT_CODE in "${EXIT_CODES[@]}"; do
 :> "${STDERR}"
 PATH="src/test/bash/mocks/ripgrep/bin:${PATH}" \
  MOCKS_RG_EXIT_CODE="${MOCKS_RG_EXIT_CODE}" \
  "${SCRIPT}" "${TMP_PATH}" "${ASSERTS_SUBTEXT}" 2>"${STDERR}"; CODE=$?
 if [[ "${CODE}" != '1' ]]; then
  echo "Code(${CODE}) error!" >&2; exit 1; fi
 ACTUAL_VALUE="$(<"${STDERR}")"
 if [[ "${ACTUAL_VALUE}" != 'Read file error!' ]]; then
  echo "Actual value(${#ACTUAL_VALUE}) is: \"${ACTUAL_VALUE}\"!" >&2; exit 1; fi
done
rm "${TMP_PATH}"

:> "${STDERR}"
TMP_PATH="$(mktemp)"
printf '%s' 'foo' > "${TMP_PATH}"
"${SCRIPT}" "${TMP_PATH}" "${ASSERTS_SUBTEXT}" 2>"${STDERR}"; CODE=$?
if [[ "${CODE}" != '1' ]]; then
 echo "Code(${CODE}) error!" >&2; exit 1; fi
EXPECTED_VALUE="\"${TMP_PATH}\"
does not contain:
---(${#ASSERTS_SUBTEXT})
${ASSERTS_SUBTEXT}
---"
ACTUAL_VALUE="$(<"${STDERR}")"
if [[ "${ACTUAL_VALUE}" != "${EXPECTED_VALUE}" ]]; then
 echo "Actual value(${#ACTUAL_VALUE}) is: \"${ACTUAL_VALUE}\"!" >&2; exit 1; fi
rm "${TMP_PATH}"

ACTUAL_TEXT='--foo--'
ASSERTS_SUBTEXTS=('-' '--' '--foo' 'foo--' '--foo--')
for ASSERTS_SUBTEXT in "${ASSERTS_SUBTEXTS[@]}"; do
 :> "${STDERR}"
 printf '%s' "${ACTUAL_TEXT}" > "${TMP_PATH}"
 "${SCRIPT}" "${TMP_PATH}" "${ASSERTS_SUBTEXT}" 2>"${STDERR}"; CODE=$?
 if [[ "${CODE}" != '0' ]]; then
  echo "Code(${CODE}) error!" >&2; exit 1; fi
 ACTUAL_VALUE="$(<"${STDERR}")"
 if [[ -n "${ACTUAL_VALUE}" ]]; then
  echo "Actual value(${#ACTUAL_VALUE}) is: \"${ACTUAL_VALUE}\"!" >&2; exit 1; fi
done

ASSERTS_SUBTEXT='foo'
ACTUAL_TEXTS=(
 'qux foo bar'
     'foo'      'foo foo'    'foo bar'
     'foox'    'xfoo'       'xfoox'
     'foo*'    '*foo'       '*foo*'
     'foo.'    '.foo'       '.foo.'
     'foo '    ' foo'       ' foo '
    $'foo\n' $'\nfoo'     $'\nfoo\n'
   $'xfoo\n'   $'foo\nx'   $'xfoo\nx'
 $'x\nfoo'   $'\nfoox'   $'x\nfoox'
 $'x\nfoo\n' $'\nfoo\nx' $'x\nfoo\nx'
)
for ACTUAL_TEXT in "${ACTUAL_TEXTS[@]}"; do
 :> "${STDERR}"
 printf '%s' "${ACTUAL_TEXT}" > "${TMP_PATH}"
 "${SCRIPT}" "${TMP_PATH}" "${ASSERTS_SUBTEXT}" 2>"${STDERR}"; CODE=$?
 if [[ "${CODE}" != '0' ]]; then
  echo "Code(${CODE}) error!" >&2; exit 1; fi
 ACTUAL_VALUE="$(<"${STDERR}")"
 if [[ -n "${ACTUAL_VALUE}" ]]; then
  echo "Actual value(${#ACTUAL_VALUE}) is: \"${ACTUAL_VALUE}\"!" >&2; exit 1; fi
done

ASSERTS_SUBTEXT=$'foo\nbar'
ACTUAL_TEXTS=(
    $'foo\nbar\n' $'\nfoo\nbar'     $'\nfoo\nbar\n'
   $'xfoo\nbar\n'   $'foo\nbar\nx'   $'xfoo\nbar\nx'
 $'x\nfoo\nbar'   $'\nfoo\nbarx'   $'x\nfoo\nbarx'
 $'x\nfoo\nbar\n' $'\nfoo\nbar\nx' $'x\nfoo\nbar\nx'
)
for ACTUAL_TEXT in "${ACTUAL_TEXTS[@]}"; do
 :> "${STDERR}"
 printf '%s' "${ACTUAL_TEXT}" > "${TMP_PATH}"
 "${SCRIPT}" "${TMP_PATH}" "${ASSERTS_SUBTEXT}" 2>"${STDERR}"; CODE=$?
 if [[ "${CODE}" != '0' ]]; then
  echo "Code(${CODE}) error!" >&2; exit 1; fi
 ACTUAL_VALUE="$(<"${STDERR}")"
 if [[ -n "${ACTUAL_VALUE}" ]]; then
  echo "Actual value(${#ACTUAL_VALUE}) is: \"${ACTUAL_VALUE}\"!" >&2; exit 1; fi
done
rm "${TMP_PATH}"

rm "${STDERR}"
