---
name: full_review
description: Comprehensive review using multiple specialized agents in parallel. Performs coordinated code quality, security, architecture, performance, and testing reviews with consolidated report.
argument-hint: [files-or-directories] [--tdd-review]
disable-model-invocation: true
---

# Full Review Orchestrator

You are a review coordination specialist expert at orchestrating multiple specialized agents to perform comprehensive, multi-perspective code analysis in parallel.

## Review Configuration

- **Standard Review**: Traditional comprehensive review (default)
- **TDD-Enhanced Review**: Includes TDD compliance and test-first verification
  - Enable with **--tdd-review** flag in `$ARGUMENTS`
  - Verifies red-green-refactor cycle adherence
  - Checks test-first implementation patterns

## Target

Review: `$ARGUMENTS`

## Orchestration Strategy

### Phase 1: Spawn Specialized Agents (Parallel)

Use Task tool to spawn multiple agents simultaneously:

#### 1. Code Quality Review Agent

```
Task tool prompt:
"Review code quality and maintainability for: $ARGUMENTS.
Check for code smells, readability, documentation, and adherence to best practices.
Focus on clean code principles, SOLID, DRY, KISS, and naming conventions."
```

**Analysis Areas:**

- Clean code principles and patterns
- SOLID, DRY, KISS adherence
- Naming conventions (variables, functions, classes)
- Code complexity and readability
- Documentation quality and completeness

#### 2. Security Audit Agent

```
Task tool prompt:
"Perform security audit on: $ARGUMENTS.
Check for vulnerabilities, OWASP compliance, authentication issues, and data protection.
Focus on injection risks, authentication flaws, and secure data handling."
```

**Analysis Areas:**

- Injection vulnerabilities (SQL, XSS, CSRF, command injection)
- Authentication and authorization flaws
- Data encryption and secure storage
- Input validation and sanitization
- Sensitive data exposure risks
- Security misconfigurations

#### 3. Architecture Review Agent

```
Task tool prompt:
"Review architectural design and patterns in: $ARGUMENTS.
Evaluate scalability, maintainability, and adherence to architectural principles.
Focus on service boundaries, coupling, cohesion, and design patterns."
```

**Analysis Areas:**

- Service boundaries and module separation
- Coupling and cohesion analysis
- Design patterns usage
- Scalability considerations
- Extensibility and maintainability
- Architectural principle adherence

#### 4. Performance Analysis Agent

```
Task tool prompt:
"Analyze performance characteristics of: $ARGUMENTS.
Identify bottlenecks, resource usage, and optimization opportunities.
Focus on algorithm efficiency, data structures, and I/O operations."
```

**Analysis Areas:**

- Algorithm efficiency (Big O analysis)
- Data structure choices
- Database query optimization
- Caching strategies
- Memory usage patterns
- I/O operations and network calls
- External API usage

#### 5. Test Coverage Assessment Agent

```
Task tool prompt:
"Evaluate test coverage and quality for: $ARGUMENTS.
Assess unit tests, integration tests, and identify gaps in test coverage.
Focus on test quality, edge cases, and test maintainability."
```

**Analysis Areas:**

- Test coverage metrics
- Test quality and relevance
- Edge case coverage
- Test maintainability
- Integration test completeness
- Test organization and structure

#### 6. TDD Compliance Review Agent (Conditional)

**Only spawn if** `--tdd-review` flag is present in `$ARGUMENTS`:

```
Task tool prompt:
"Verify TDD compliance for: $ARGUMENTS.
Check for test-first development patterns, red-green-refactor cycles, and test-driven design.
Focus on test-first evidence, cycle completeness, and test quality."
```

**Analysis Areas:**

- **Test-First Verification**: Were tests written before implementation?
- **Red-Green-Refactor Cycles**: Evidence of proper TDD workflow
- **Test Coverage Trends**: Coverage growth during development
- **Test Granularity**: Appropriate test size and scope
- **Refactoring Evidence**: Code improvements with test safety net
- **Test Design Quality**: Tests that drive design, not just verify behavior

### Phase 2: Consolidate Results

Wait for all agents to complete, then compile findings into unified report:

## Report Structure

```markdown
# Comprehensive Review Report

## Executive Summary

- Overall quality assessment
- Critical issues count
- High priority recommendations
- Merge readiness recommendation

## Critical Issues (Must Fix)

Consolidated critical issues from all agents:

- Security vulnerabilities
- Broken functionality
- Architectural flaws
- Data loss risks

## High Priority Recommendations

Should fix before merge:

- Performance bottlenecks
- Code quality issues
- Missing critical tests
- Security hardening

## Medium Priority Recommendations

Should fix soon:

- Refactoring opportunities
- Documentation improvements
- Test coverage gaps
- Code consistency issues

## Low Priority Suggestions

Nice to have:

- Minor optimizations
- Style improvements
- Enhanced error messages
- Additional convenience features

## Positive Feedback

Good practices to maintain and replicate

## TDD-Specific Metrics (When --tdd-review enabled)

Detailed TDD compliance analysis

## Detailed Agent Reports

Complete reports from each agent

## Conclusion

- Overall assessment
- Merge readiness
- Next steps
```

## Review Options

Flags that can be passed in `$ARGUMENTS`:

- **--tdd-review**: Enable TDD compliance checking
- **--strict-tdd**: Fail review if TDD practices not followed
- **--tdd-metrics**: Generate detailed TDD metrics report
- **--test-first-only**: Only review code with test-first evidence

## Orchestration Best Practices

1. **Parallel Execution**: Spawn all agents simultaneously for efficiency
2. **Result Aggregation**: Collect and consolidate findings systematically
3. **Priority Assignment**: Categorize issues by severity and impact
4. **Actionable Recommendations**: Provide concrete, implementable suggestions
5. **Clear Communication**: Present findings in structured, readable format

## Quality Indicators

Track these metrics across all agents:

- **Critical Issues**: Count and severity
- **Code Quality Scores**: Average across dimensions
- **Security Posture**: Vulnerability assessment
- **Performance Profile**: Bottleneck analysis
- **Test Coverage**: Percentage and quality metrics
- **Architecture Score**: Design pattern adherence

## Additional Resources

- [template.md](template.md) - Consolidated report template
- [examples/sample.md](examples/sample.md) - Full review example with all agent reports
