---
description: Create a well-formatted conventional commit via the commit skill
---

Load the `commit` skill using the `skill` tool, then follow its instructions to commit the current changes.

Everywhere the skill refers to `$ARGUMENTS`, substitute the arguments passed to this command (e.g. a language such as `russian`, an explicit `jj` or `git` backend, or extra user context):

```
$ARGUMENTS
```

If no arguments were provided, proceed with skill defaults: auto-detect the VCS backend and write the commit message in English.
