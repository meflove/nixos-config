---
description: Full multi-agent review (quality, security, architecture, performance, tests) via the full_review skill
---

Load the `full_review` skill using the `skill` tool, then follow its instructions to orchestrate the parallel review agents.

Everywhere the skill refers to `$ARGUMENTS`, substitute the arguments passed to this command (review target plus optional flags such as `--tdd-review`, `--strict-tdd`, `--tdd-metrics`, `--test-first-only`):

```
$ARGUMENTS
```

If no arguments were provided, ask the user which files, directories, or changes to review before spawning the agents.
