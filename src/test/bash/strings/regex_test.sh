#!/usr/local/bin/bash

SCRIPT='src/main/bash/strings/regex.sh'

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

"${SCRIPT}" '' '' 2>"${STDERR}"; CODE=$?
if [[ "${CODE}" != '1' ]]; then
 echo "Code(${CODE}) error!" >&2; exit 1; fi
ACTUAL_VALUE="$(<"${STDERR}")"
if [[ "${ACTUAL_VALUE}" != 'Wrong arguments!' ]]; then
 echo "Actual value(${#ACTUAL_VALUE}) is: \"${ACTUAL_VALUE}\"!" >&2; exit 1; fi

:> "${STDERR}"

"${SCRIPT}" '' '' '' '' 2>"${STDERR}"; CODE=$?
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
if [[ "${ACTUAL_VALUE}" != 'No context!' ]]; then
 echo "Actual value(${#ACTUAL_VALUE}) is: \"${ACTUAL_VALUE}\"!" >&2; exit 1; fi

:> "${STDERR}"

"${SCRIPT}" '42' 'hello' '' 2>"${STDERR}"; CODE=$?
if [[ "${CODE}" != '1' ]]; then
 echo "Code(${CODE}) error!" >&2; exit 1; fi
ACTUAL_VALUE="$(<"${STDERR}")"
if [[ "${ACTUAL_VALUE}" != 'No regex!' ]]; then
 echo "Actual value(${#ACTUAL_VALUE}) is: \"${ACTUAL_VALUE}\"!" >&2; exit 1; fi

# Expects "Invalid regex" for malformed ERE patterns.

ASSERTS_REGEXES=('(' '[' '[z-a]' '*' '**')
for ASSERTS_REGEX in "${ASSERTS_REGEXES[@]}"; do
 :> "${STDERR}"
 "${SCRIPT}" '42' '' "${ASSERTS_REGEX}" 2>"${STDERR}"; CODE=$?
 if [[ "${CODE}" != '1' ]]; then
  echo "Code(${CODE}) error!" >&2; exit 1; fi
 EXPECTED_VALUE="Context: \"42\"
Invalid regex:
---(${#ASSERTS_REGEX})
${ASSERTS_REGEX}
---"
 ACTUAL_VALUE="$(<"${STDERR}")"
 if [[ "${ACTUAL_VALUE}" != "${EXPECTED_VALUE}" ]]; then
  echo "Actual value(${#ACTUAL_VALUE}) is: \"${ACTUAL_VALUE}\"!" >&2; exit 1; fi
done

:> "${STDERR}"

# Expects mismatch output when text does not match anchored regex.

"${SCRIPT}" '42' 'foo' '^bar$' 2>"${STDERR}"; CODE=$?
if [[ "${CODE}" != '1' ]]; then
 echo "Code(${CODE}) error!" >&2; exit 1; fi
EXPECTED_VALUE='Context: "42"
---(3)
foo
---
does not satisfy the regex:
---(5)
^bar$
---'
ACTUAL_VALUE="$(<"${STDERR}")"
if [[ "${ACTUAL_VALUE}" != "${EXPECTED_VALUE}" ]]; then
 echo "Actual value(${#ACTUAL_VALUE}) is: \"${ACTUAL_VALUE}\"!" >&2; exit 1; fi

# Expects success for each text containing "foo" under ^.*foo.*$.

ACTUAL_TEXTS=('foo' ' foo' 'foo ' ' foo ' 'foo foo' 'foo bar' 'qux foo bar' 'qux\nfoo\nbar' $'qux\nfoo\nbar')
for ASSERTS_TEXT in "${ACTUAL_TEXTS[@]}"; do
 :> "${STDERR}"
 "${SCRIPT}" '42' "${ASSERTS_TEXT}" '^.*foo.*$' 2>"${STDERR}"; CODE=$?
 if [[ "${CODE}" != '0' ]]; then
  echo "Code(${CODE}) error!" >&2; exit 1; fi
 ACTUAL_VALUE="$(<"${STDERR}")"
 if [[ -n "${ACTUAL_VALUE}" ]]; then
  echo "Actual value(${#ACTUAL_VALUE}) is: \"${ACTUAL_VALUE}\"!" >&2; exit 1; fi
done

# Expects mismatch for texts against self.
# FOO='\n' "${FOO}" =~ ${FOO} -> \n contains n
# FOO=$'\n' "${FOO}" =~ ${FOO} -> $'\n' contains $'\n'
# FOO='a\n' "${FOO}" =~ ${FOO} -> a\n not contains an
# FOO=$'a\n' "${FOO}" =~ ${FOO} -> a$'\n' contains a$'\n'

ACTUAL_TEXTS=('a' ')' ']' '\n' $'\n' $'a\n')
for ASSERTS_TEXT in "${ACTUAL_TEXTS[@]}"; do
 :> "${STDERR}"
 "${SCRIPT}" '42' "${ASSERTS_TEXT}" "${ASSERTS_TEXT}" 2>"${STDERR}"; CODE=$?
 if [[ "${CODE}" != '0' ]]; then
  echo "Code(${CODE}) error!" >&2; exit 1; fi
 ACTUAL_VALUE="$(<"${STDERR}")"
 if [[ -n "${ACTUAL_VALUE}" ]]; then
  echo "Actual value(${#ACTUAL_VALUE}) is: \"${ACTUAL_VALUE}\"!" >&2; exit 1; fi
done

# Expects mismatch for non-empty one-char texts against ^$.

ACTUAL_TEXTS=(' ' $'\n' $'\t')
for ASSERTS_TEXT in "${ACTUAL_TEXTS[@]}"; do
 :> "${STDERR}"
 "${SCRIPT}" '42' "${ASSERTS_TEXT}" '^$' 2>"${STDERR}"; CODE=$?
 if [[ "${CODE}" != '1' ]]; then
  echo "Code(${CODE}) error!" >&2; exit 1; fi
 EXPECTED_VALUE="Context: \"42\"
---(1)
${ASSERTS_TEXT}
---
does not satisfy the regex:
---(2)
^$
---"
 ACTUAL_VALUE="$(<"${STDERR}")"
 if [[ "${ACTUAL_VALUE}" != "${EXPECTED_VALUE}" ]]; then
  echo "Actual value(${#ACTUAL_VALUE}) is: \"${ACTUAL_VALUE}\"!" >&2; exit 1; fi
done

# Expects success for empty text with regexes that allow emptiness.

ASSERTS_REGEXES=('.*' '^$')
for ASSERTS_REGEX in "${ASSERTS_REGEXES[@]}"; do
 :> "${STDERR}"
 "${SCRIPT}" '42' '' "${ASSERTS_REGEX}" 2>"${STDERR}"; CODE=$?
 if [[ "${CODE}" != '0' ]]; then
  echo "Code(${CODE}) error!" >&2; exit 1; fi
 ACTUAL_VALUE="$(<"${STDERR}")"
 if [[ -n "${ACTUAL_VALUE}" ]]; then
  echo "Actual value(${#ACTUAL_VALUE}) is: \"${ACTUAL_VALUE}\"!" >&2; exit 1; fi
done

:> "${STDERR}"

# Expects mismatch when text has real LF but regex contains literal \n.
# FOO=$'\n1' BAR='\n1' "${FOO}" =~ ${BAR} -> $'\n'1 not satisfy {\n}1

ASSERTS_TEXT=$'foo\n1\n55\nbaz'
ASSERTS_REGEX='(^|\n)[1-4]{1}\n[5-7]{2}($|\n)'
"${SCRIPT}" '42' "${ASSERTS_TEXT}" "${ASSERTS_REGEX}" 2>"${STDERR}"; CODE=$?
if [[ "${CODE}" != '1' ]]; then
 echo "Code(${CODE}) error!" >&2; exit 1; fi
EXPECTED_VALUE='Context: "42"
---(12)
foo
1
55
baz
---
does not satisfy the regex:
---(30)
(^|\n)[1-4]{1}\n[5-7]{2}($|\n)
---'
ACTUAL_VALUE="$(<"${STDERR}")"
if [[ "${ACTUAL_VALUE}" != "${EXPECTED_VALUE}" ]]; then
 echo "Actual value(${#ACTUAL_VALUE}) is: \"${ACTUAL_VALUE}\"!" >&2; exit 1; fi

:> "${STDERR}"

# FOO='\n1' BAR='\n1' "${FOO}" =~ ${BAR} -> \n1 not satisfy {\n}1

ASSERTS_TEXT='foo\n1\n55\nbaz'
ASSERTS_REGEX='(^|\n)[1-4]{1}\n[5-7]{2}($|\n)'
"${SCRIPT}" '42' "${ASSERTS_TEXT}" "${ASSERTS_REGEX}" 2>"${STDERR}"; CODE=$?
if [[ "${CODE}" != '1' ]]; then
 echo "Code(${CODE}) error!" >&2; exit 1; fi
EXPECTED_VALUE='Context: "42"
---(15)
foo\n1\n55\nbaz
---
does not satisfy the regex:
---(30)
(^|\n)[1-4]{1}\n[5-7]{2}($|\n)
---'
ACTUAL_VALUE="$(<"${STDERR}")"
if [[ "${ACTUAL_VALUE}" != "${EXPECTED_VALUE}" ]]; then
 echo "Actual value(${#ACTUAL_VALUE}) is: \"${ACTUAL_VALUE}\"!" >&2; exit 1; fi

:> "${STDERR}"

# Expects success when both text and regex contain real LF characters.
# FOO=$'\n1' BAR=$'\n1' "${FOO}" =~ ${BAR} -> $'\n'1 satisfy $'\n'1

ASSERTS_TEXT=$'foo\n1\n55\nbaz'
ASSERTS_REGEX=$'(^|\n)[1-4]{1}\n[5-7]{2}($|\n)'
"${SCRIPT}" '42' "${ASSERTS_TEXT}" "${ASSERTS_REGEX}" 2>"${STDERR}"; CODE=$?
if [[ "${CODE}" != '0' ]]; then
 echo "Code(${CODE}) error!" >&2; exit 1; fi
ACTUAL_VALUE="$(<"${STDERR}")"
if [[ -n "${ACTUAL_VALUE}" ]]; then
 echo "Actual value(${#ACTUAL_VALUE}) is: \"${ACTUAL_VALUE}\"!" >&2; exit 1; fi

:> "${STDERR}"

# Expects success when both text and regex use literal backslash-n.
# FOO='\n1' BAR='\\n1' "${FOO}" =~ ${BAR} -> \n1 satisfy \n1

ASSERTS_TEXT='foo\n1\n55\nbaz'
ASSERTS_REGEX='(^|\\n)[1-4]{1}\\n[5-7]{2}($|\\n)'
"${SCRIPT}" '42' "${ASSERTS_TEXT}" "${ASSERTS_REGEX}" 2>"${STDERR}"; CODE=$?
if [[ "${CODE}" != '0' ]]; then
 echo "Code(${CODE}) error!" >&2; exit 1; fi
ACTUAL_VALUE="$(<"${STDERR}")"
if [[ -n "${ACTUAL_VALUE}" ]]; then
 echo "Actual value(${#ACTUAL_VALUE}) is: \"${ACTUAL_VALUE}\"!" >&2; exit 1; fi

rm "${STDERR}"
