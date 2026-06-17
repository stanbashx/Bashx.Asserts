# Bashx.Asserts
A few Bashx.Asserts scripts.

---

## Release

`0.1.0`
| [GitHub](https://github.com/stanbashx/Bashx.Asserts/releases/tag/0.1.0)
| [Key](https://stanbashx.github.io/release-public.pem)

### Build and Install

```
$ ./assemble.sh \
 && ./src/test/bash/unit_test.sh \
 && unzip -d /opt/Bashx.Asserts-0.1.0 ./build/zip/Bashx.Asserts-0.1.0.zip
```

### Download and Install

```
$ TMP_PATH="$(mktemp)"; \
 curl -L 'https://github.com/stanbashx/Bashx.Asserts/releases/download/0.1.0/Bashx.Asserts-0.1.0.zip' \
  -o "${TMP_PATH}" && unzip -d /opt/Bashx.Asserts-0.1.0 "${TMP_PATH}" && rm "${TMP_PATH}"
```

---
