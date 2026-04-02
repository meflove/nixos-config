---
name: commit
description: Creates well-formatted commits with conventional commit messages and emoji. Use when you need to commit changes with proper commit message format.
argument-hint: [language]
disable-model-invocation: true
allowed-tools: Bash(git *)
---

# Commit

You are an expert at analyzing code differences and generating high-quality commit messages in Conventional Commits format.

## Context

- Current git status: !`git status`
- Current git diff: !`git diff HEAD`
- Recent commits: !`git log --oneline -5`

## Rules

- **Work only with staged files** - don't add files using `git add`
- **Follow Conventional Commits format** with emoji
- **No promotional messages** - don't add "Generated with..." or similar

## Commit Message Format

```
<emoji> <type>[optional scope]: <description>

<bullet points summarizing changes>
```

## Algorithm

### 1. Analyze `git diff` output

Carefully examine the changed files to:

- Determine the nature of changes
- Find connections between changes in different files
- Understand the WHY behind each change

### 2. Analyze commit history

Review recent commits for context and ensure consistency with previous commit styles.

### 3. Determine `<type>`

Choose the most appropriate type:

- `feat`: ✨ New functionality
- `fix`: 🐛 Bug fix
- `docs`: 📚 Documentation changes only
- `style`: 🎨 Code formatting (no logic changes)
- `refactor`: 🔨 Code restructuring (no behavior change)
- `perf`: ⚡ Performance improvements
- `test`: 🧪 Adding or fixing tests
- `chore`: 🔧 Maintenance (tools, dependencies)
- `ci`: 🤖 CI/CD changes
- `build`: 🏗️ Build system changes
- `revert`: ⏪ Revert previous commit

### 4. Determine `[optional scope]`

If changes affect a specific part of the codebase, specify it in parentheses:

- `feat(auth):` - authentication changes
- `fix(ui):` - UI bug fixes
- `refactor(api):` - API refactoring
- Omit scope for global changes

### 5. Create `<description>`

- **Maximum 50 characters**
- **Lowercase**, no period at end
- **Clear description of WHAT changed**

### 6. Create bullet points

- Start with hyphen `-`
- **Concise and to the point** - explain WHY changes are needed
- **High-level abstraction** - avoid excessive detail

### 7. Check language and tone

Language from `$ARGUMENTS` (default: English). Use professional, neutral language.

### 8. Ask for confirmation

- Print the generated commit message
- Ask user to confirm or request changes
- After confirmation, run `git commit -m "<commit message>"`

## Examples

### Example 1: Adding new functionality ✨

```
✨ feat(auth): add JWT token validation

- Implement JWT token validation middleware
- Add error handling for expired tokens
- Update authentication flow to use new validator
```

### Example 2: Bug fix 🐛

```
🐛 fix(ui): handle null pointer in sidebar

- Add null checks for user data
- Prevent crashes when profile is missing
- Add fallback UI for incomplete data
```

### Example 3: Refactoring 🔨

```
🔨 refactor(api): split user controller logic

- Extract validation logic to separate service
- Move database operations to repository layer
- Simplify controller for better maintainability
```

## What to Avoid

**Bad titles:**

- "update", "fix stuff", "changes" - too generic
- "Fixed the bug in the login form" - capitalized and with period
- "Added very important feature for user authentication" - too long

**Bad bullet points:**

- Excessive detail: "Changed line 42 in user.js from false to true"
- Describing WHAT instead of WHY: "Added function validateToken" instead of "Add token validation for security"

## Final Checklist

Before submitting the commit message, check:

1. [ ] Title ≤ 50 characters
2. [ ] Type matches change nature
3. [ ] No promotional messages
4. [ ] Bullet points explain WHY, not just WHAT
5. [ ] Checked for grammar and spelling
6. [ ] Asked for user confirmation

## Additional Resources

- For commit message template, see [template.md](template.md)
- For example output, see [examples/sample.md](examples/sample.md)
