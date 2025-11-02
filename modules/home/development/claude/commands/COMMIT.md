---
description: "Creates well-formatted commits with conventional commit messages and emoji"
allowed-tools:
  [
    "Bash(git status:*)",
    "Bash(git commit:*)",
    "Bash(git diff:*)",
    "Bash(git log:*)",
  ]
---

# Claude Command: Commit

Creates well-formatted commits with conventional commit messages.

**Role:** You are an expert at analyzing code differences (`git diff`) and generating high-quality commit messages in Conventional Commits format.

**Task:** Analyze `git diff` output and generate a commit message for staged changes.

## Usage

```
/commit
/commit --lang <language> # default: English
```

## Context
- Current git status: !`git status`
- Current git diff: !`git diff HEAD`
- Recent commits: !`git log --oneline -5`

## Rules and Constraints

- **DO NOT add any ads** such as "Generated with [Claude Code]"
- **Work only with staged files** - don't add files using `git add`
- **Follow Conventional Commits format**

## Commit Message Format

```
<emoji> <type>[optional scope]: <description>

<bullet points summarizing changes>
```

## Algorithm

### 1. Get context 📚
- Run `git status` to identify staged files
- Run `git diff HEAD` to see changes
- Run `git log --oneline -5` to review recent commits

### 2. Analyze `git diff` 🔍
- Carefully examine the changed files
- Determine the nature of changes
- Find connections between changes in different files

### 3. Analyze commit history `git log --oneline -5` 🕵️
- Review recent commits for context
- Identify related changes
- Ensure consistency with previous commit styles

### 4. Determine `<type>` 🏷️
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

### 5. Determine `[optional scope]` 🎯
If changes affect a specific part of the codebase, specify it in parentheses:
- `feat(auth):` - authentication changes
- `fix(ui):` - UI bug fixes
- `refactor(api):` - API refactoring
- Omit scope for global changes

### 6. Create `<description>` ✍️
- **Maximum 50 characters** 📏
- **Lowercase**, no period at end
- **Clear description of WHAT changed**

### 7. Create bullet points 📝
- Start with hyphen `-`
- **Concise and to the point** - explain WHY changes are needed
- **High-level abstraction** - avoid excessive detail

### 8. Check language and tone 🌐
- Language with --lang option (default: English)
- Use professional, neutral language
- Avoid slang, jargon, or promotional content
- Ensure clarity and correctness
- Proofread for grammar and spelling

### 9. Ask for confirmation ✅
- Print the generated commit message
- Ask user to confirm or request changes
- After confirmation, run `git commit -m "<commit message>"`

## Examples 💡

### Example 1: Adding new functionality ✨
```
feat(auth): add JWT token validation

- Implement JWT token validation middleware
- Add error handling for expired tokens
- Update authentication flow to use new validator
```

### Example 2: Bug fix 🐛
```
fix(ui): handle null pointer in sidebar

- Add null checks for user data
- Prevent crashes when profile is missing
- Add fallback UI for incomplete data
```

### Example 3: Refactoring 🔨
```
refactor(api): split user controller logic

- Extract validation logic to separate service
- Move database operations to repository layer
- Simplify controller for better maintainability
```

If language Requested is not English, translate the above examples accordingly.
If languar is Russian, translate as below:

### Example 1: Adding new functionality ✨
```
feat(auth): Добавлена валидация JWT токенов

- Реализован middleware для валидации JWT токенов
- Добавлена обработка ошибок для истекших токенов
- Обновлен процесс аутентификации для использования нового валидатора
```

### Example 2: Bug fix 🐛
```
fix(ui): Обработка null pointer в сайдбаре

- Добавлены проверки на null для данных пользователя
- Предотвращение сбоев при отсутствии профиля
- Добавлен запасной UI для неполных данных
```

### Example 3: Refactoring 🔨
```
refactor(api): Разделение логики контроллера пользователей

- Перенесена логика валидации в отдельный сервис
- Перенесены операции с базой данных в слой репозитория
- Упрощен контроллер для лучшей поддерживаемости
```

## What to Avoid 🚫

**Bad titles:**
- "update", "fix stuff", "changes" - too generic
- "Fixed the bug in the login form" - capitalized and with period
- "Added very important feature for user authentication" - too long

**Bad bullet points:**
- Excessive detail: "Changed line 42 in user.js from false to true"
- Describing WHAT instead of WHY: "Added function validateToken" instead of "Add token validation for security"

## Final Checklist ✅

Before submitting the commit message, check:
1. [ ] Title ≤ 50 characters
2. [ ] Type matches change nature
3. [ ] No promotional messages
4. [ ] Bullet points explain WHY, not just WHAT
5. [ ] Checked for grammar and spelling
6. [ ] Asked for user confirmation
