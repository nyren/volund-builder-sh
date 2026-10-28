# volund-builder-sh

[![pipeline](https://github.com/nyren/volund-builder-sh/actions/workflows/pipeline.yml/badge.svg?branch=master&event=push)](https://github.com/nyren/volund-builder-sh/actions/workflows/pipeline.yml)

[Volund](https://github.com/nyren/volund) Builder Image providing basic shell commands.

Example usage in `build.sh`:

```
. volund/lib/core

volund_image sh ghcr.io/nyren/volund-release/volund-builder-sh:0.3.0

init() {
    volund_script sh "demo" << VOLUND_EOF
echo "hello world" | sed 's/^h/H/'
VOLUND_EOF
}

volund_main "$@"
```
