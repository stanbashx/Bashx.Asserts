# Bashx.Asserts
A few assertion scripts.

---

## Release

`0.1.2`
| [GitHub](https://github.com/stanbashx/Bashx.Asserts/releases/tag/0.1.2)
| [Key](https://stanbashx.github.io/release-public.pem)

### Build and Install

```
$ ./assemble.sh \
 && ./src/test/bash/unit_test.sh \
 && unzip -d /opt/Bashx.Asserts-0.1.2 ./build/zip/Bashx.Asserts-0.1.2.zip
```

### Download and Install

```
$ TMP_PATH="$(mktemp)"; \
 curl -L 'https://github.com/stanbashx/Bashx.Asserts/releases/download/0.1.2/Bashx.Asserts-0.1.2.zip' \
  -o "${TMP_PATH}" && unzip -d /opt/Bashx.Asserts-0.1.2 "${TMP_PATH}" && rm "${TMP_PATH}"
```

---
