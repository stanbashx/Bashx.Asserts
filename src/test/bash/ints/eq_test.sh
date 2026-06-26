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
"${SCRIPT}" '' > "${STDOUT}" 2> "${STDERR}"; CODE=$?
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

:> "${STDOUT}"
:> "${STDERR}"
ASSERTS_CONTEXT=''
ASSERTS_ACTUAL=''
ASSERTS_EXPECTED=''
"${SCRIPT}" "${ASSERTS_CONTEXT}" "${ASSERTS_ACTUAL}" "${ASSERTS_EXPECTED}" > "${STDOUT}" 2> "${STDERR}"; CODE=$?
if [[ "${CODE}" != '1' ]]; then
 echo "Code(${CODE}) error!" >&2; exit 1; fi
if [[ -n "$(<"${STDOUT}")" ]]; then
 echo "Script \"${SCRIPT}\" has stdout!" >&2; exit 1; fi
ACTUAL_VALUE="$(<"${STDERR}")"
if [[ "${ACTUAL_VALUE}" != 'No context!' ]]; then
 echo "Actual value(${#ACTUAL_VALUE}) is: \"${ACTUAL_VALUE}\"!" >&2; exit 1; fi

VALUES=('' 'a' '-' ' ' $'\n' $'\t' '-0' '+0' '+1' '0.5' '0,5' '05')
for ASSERTS_ACTUAL in "${VALUES[@]}"; do
 :> "${STDOUT}"
 :> "${STDERR}"
 ASSERTS_CONTEXT='foo'
 ASSERTS_EXPECTED=''
 "${SCRIPT}" "${ASSERTS_CONTEXT}" "${ASSERTS_ACTUAL}" "${ASSERTS_EXPECTED}" > "${STDOUT}" 2> "${STDERR}"; CODE=$?
 if [[ "${CODE}" != '1' ]]; then
  echo "Code(${CODE}) error!" >&2; exit 1; fi
 if [[ -n "$(<"${STDOUT}")" ]]; then
  echo "Script \"${SCRIPT}\" has stdout!" >&2; exit 1; fi
 ACTUAL_VALUE="$(<"${STDERR}")"
 if [[ "${ACTUAL_VALUE}" != "Actual(${#ASSERTS_ACTUAL}): \"${ASSERTS_ACTUAL}\" is not a number!" ]]; then
  echo "Actual value(${#ACTUAL_VALUE}) is: \"${ACTUAL_VALUE}\"!" >&2; exit 1; fi
done

VALUES=('-2147483649' '2147483648')
for ASSERTS_ACTUAL in "${VALUES[@]}"; do
 :> "${STDOUT}"
 :> "${STDERR}"
 ASSERTS_CONTEXT='foo'
 ASSERTS_EXPECTED=''
 "${SCRIPT}" "${ASSERTS_CONTEXT}" "${ASSERTS_ACTUAL}" "${ASSERTS_EXPECTED}" > "${STDOUT}" 2> "${STDERR}"; CODE=$?
 if [[ "${CODE}" != '1' ]]; then
  echo "Code(${CODE}) error!" >&2; exit 1; fi
 if [[ -n "$(<"${STDOUT}")" ]]; then
  echo "Script \"${SCRIPT}\" has stdout!" >&2; exit 1; fi
 ACTUAL_VALUE="$(<"${STDERR}")"
 if [[ "${ACTUAL_VALUE}" != "Actual: ${ASSERTS_ACTUAL} is not an int32!" ]]; then
  echo "Actual value(${#ACTUAL_VALUE}) is: \"${ACTUAL_VALUE}\"!" >&2; exit 1; fi
done

VALUES=('' 'a' '-' ' ' $'\n' $'\t' '-0' '+0' '+1' '0.5' '0,5' '05')
for ASSERTS_EXPECTED in "${VALUES[@]}"; do
 :> "${STDOUT}"
 :> "${STDERR}"
 ASSERTS_CONTEXT='foo'
 ASSERTS_ACTUAL='42'
 "${SCRIPT}" "${ASSERTS_CONTEXT}" "${ASSERTS_ACTUAL}" "${ASSERTS_EXPECTED}" > "${STDOUT}" 2> "${STDERR}"; CODE=$?
 if [[ "${CODE}" != '1' ]]; then
  echo "Code(${CODE}) error!" >&2; exit 1; fi
 if [[ -n "$(<"${STDOUT}")" ]]; then
  echo "Script \"${SCRIPT}\" has stdout!" >&2; exit 1; fi
 ACTUAL_VALUE="$(<"${STDERR}")"
 if [[ "${ACTUAL_VALUE}" != "Expected(${#ASSERTS_EXPECTED}): \"${ASSERTS_EXPECTED}\" is not a number!" ]]; then
  echo "Actual value(${#ACTUAL_VALUE}) is: \"${ACTUAL_VALUE}\"!" >&2; exit 1; fi
done

VALUES=('-2147483649' '2147483648')
for ASSERTS_EXPECTED in "${VALUES[@]}"; do
 :> "${STDOUT}"
 :> "${STDERR}"
 ASSERTS_CONTEXT='foo'
 ASSERTS_ACTUAL='42'
 "${SCRIPT}" "${ASSERTS_CONTEXT}" "${ASSERTS_ACTUAL}" "${ASSERTS_EXPECTED}" > "${STDOUT}" 2> "${STDERR}"; CODE=$?
 if [[ "${CODE}" != '1' ]]; then
  echo "Code(${CODE}) error!" >&2; exit 1; fi
 if [[ -n "$(<"${STDOUT}")" ]]; then
  echo "Script \"${SCRIPT}\" has stdout!" >&2; exit 1; fi
 ACTUAL_VALUE="$(<"${STDERR}")"
 if [[ "${ACTUAL_VALUE}" != "Expected: ${ASSERTS_EXPECTED} is not an int32!" ]]; then
  echo "Actual value(${#ACTUAL_VALUE}) is: \"${ACTUAL_VALUE}\"!" >&2; exit 1; fi
done

VALUES=('-42' '-8' '0' '1' '2' '4' '8' '16' '32' '64' '-2147483648' '2147483647')
for ASSERTS_ACTUAL in "${VALUES[@]}"; do
 :> "${STDOUT}"
 :> "${STDERR}"
 ASSERTS_CONTEXT='foo'
 ASSERTS_EXPECTED='42'
 "${SCRIPT}" "${ASSERTS_CONTEXT}" "${ASSERTS_ACTUAL}" "${ASSERTS_EXPECTED}" > "${STDOUT}" 2> "${STDERR}"; CODE=$?
 if [[ "${CODE}" != '1' ]]; then
  echo "Code(${CODE}) error!" >&2; exit 1; fi
 if [[ -n "$(<"${STDOUT}")" ]]; then
  echo "Script \"${SCRIPT}\" has stdout!" >&2; exit 1; fi
 ACTUAL_VALUE="$(<"${STDERR}")"
 EXPECTED_VALUE="Context: \"${ASSERTS_CONTEXT}\"
Actual: ${ASSERTS_ACTUAL}
Expected: ${ASSERTS_EXPECTED}"
 if [[ "${ACTUAL_VALUE}" != "${EXPECTED_VALUE}" ]]; then
  echo "Actual value(${#ACTUAL_VALUE}) is: \"${ACTUAL_VALUE}\"!" >&2; exit 1; fi
done

VALUES=('-42' '-8' '0' '1' '2' '4' '8' '16' '32' '64' '-2147483648' '2147483647')
for ASSERTS_EXPECTED in "${VALUES[@]}"; do
 :> "${STDOUT}"
 :> "${STDERR}"
 ASSERTS_CONTEXT='foo'
 ASSERTS_ACTUAL='42'
 "${SCRIPT}" "${ASSERTS_CONTEXT}" "${ASSERTS_ACTUAL}" "${ASSERTS_EXPECTED}" > "${STDOUT}" 2> "${STDERR}"; CODE=$?
 if [[ "${CODE}" != '1' ]]; then
  echo "Code(${CODE}) error!" >&2; exit 1; fi
 if [[ -n "$(<"${STDOUT}")" ]]; then
  echo "Script \"${SCRIPT}\" has stdout!" >&2; exit 1; fi
 ACTUAL_VALUE="$(<"${STDERR}")"
 EXPECTED_VALUE="Context: \"${ASSERTS_CONTEXT}\"
Actual: ${ASSERTS_ACTUAL}
Expected: ${ASSERTS_EXPECTED}"
 if [[ "${ACTUAL_VALUE}" != "${EXPECTED_VALUE}" ]]; then
  echo "Actual value(${#ACTUAL_VALUE}) is: \"${ACTUAL_VALUE}\"!" >&2; exit 1; fi
done

VALUES=('-42' '-8' '0' '1' '2' '4' '8' '16' '32' '64' '-2147483648' '2147483647')
for ASSERTS_ACTUAL in "${VALUES[@]}"; do
 :> "${STDOUT}"
 :> "${STDERR}"
 ASSERTS_CONTEXT='foo'
 ASSERTS_EXPECTED="${ASSERTS_ACTUAL}"
 "${SCRIPT}" "${ASSERTS_CONTEXT}" "${ASSERTS_ACTUAL}" "${ASSERTS_ACTUAL}" > "${STDOUT}" 2> "${STDERR}"; CODE=$?
 if [[ "${CODE}" != '0' ]]; then
  echo "Code(${CODE}) error!" >&2; exit 1; fi
 if [[ -n "$(<"${STDOUT}")" ]]; then
  echo "Script \"${SCRIPT}\" has stdout!" >&2; exit 1; fi
 ACTUAL_VALUE="$(<"${STDERR}")"
 if [[ -n "${ACTUAL_VALUE}" ]]; then
  echo "Actual value(${#ACTUAL_VALUE}) is: \"${ACTUAL_VALUE}\"!" >&2; exit 1; fi
done

#

rm "${STDOUT}"
rm "${STDERR}"
