# Full Review Report Template

## Review Context

**Target:** `{{TARGET}}`
**Files Reviewed:** `{{FILE_LIST}}`
**Review Type:** `{{REVIEW_TYPE}}`
**Agents Deployed:** `{{AGENTS_USED}}`
**Review Duration:** `{{DURATION}}`

## Executive Summary

**Overall Quality:** `{{OVERALL_QUALITY}}`

**Critical Issues:** `{{CRITICAL_COUNT}}`
**High Priority:** `{{HIGH_PRIORITY_COUNT}}`
**Medium Priority:** `{{MEDIUM_PRIORITY_COUNT}}`
**Low Priority:** `{{LOW_PRIORITY_COUNT}}`

**Recommendation:** `{{RECOMMENDATION}}` (Merge Ready / Needs Work / Do Not Merge)

## Critical Issues (Must Fix)

### {{CRITICAL_1_TITLE}}

- **Source:** {{CRITICAL_1_AGENT}}
- **Issue:** {{CRITICAL_1_DESCRIPTION}}
- **Risk:** {{CRITICAL_1_RISK}}
- **Must Fix:** {{CRITICAL_1_FIX}}
- **Priority:** URGENT

{{CRITICAL_2_EXISTS}}

## High Priority Recommendations

### {{HIGH_1_TITLE}}

- **Source:** {{HIGH_1_AGENT}}
- **Issue:** {{HIGH_1_DESCRIPTION}}
- **Impact:** {{HIGH_1_IMPACT}}
- **Recommendation:** {{HIGH_1_RECOMMENDATION}}
- **Priority:** High

{{HIGH_2_EXISTS}}

## Medium Priority Recommendations

### {{MEDIUM_1_TITLE}}

- **Source:** {{MEDIUM_1_AGENT}}
- **Issue:** {{MEDIUM_1_DESCRIPTION}}
- **Recommendation:** {{MEDIUM_1_RECOMMENDATION}}
- **Priority:** Medium

{{MEDIUM_2_EXISTS}}

## Low Priority Suggestions

### {{LOW_1_TITLE}}

- **Source:** {{LOW_1_AGENT}}
- **Suggestion:** {{LOW_1_DESCRIPTION}}
- **Priority:** Low

{{LOW_2_EXISTS}}

## Positive Feedback

### {{POSITIVE_1}}

- **Source:** {{POSITIVE_1_AGENT}}

### {{POSITIVE_2}}

- **Source:** {{POSITIVE_2_AGENT}}

{{TDD_SECTION_EXISTS}}

## Detailed Agent Reports

### 1. Code Quality Review

**Agent:** code-reviewer
**Status:** {{CODE_QUALITY_STATUS}}

#### Findings

{{CODE_QUALITY_FINDINGS}}

#### Recommendations

{{CODE_QUALITY_RECOMMENDATIONS}}

#### Score: {{CODE_QUALITY_SCORE}}/10

---

### 2. Security Audit

**Agent:** general-purpose
**Status:** {{SECURITY_STATUS}}

#### Findings

{{SECURITY_FINDINGS}}

#### Critical Vulnerabilities

{{SECURITY_CRITICAL}}

#### Recommendations

{{SECURITY_RECOMMENDATIONS}}

#### Score: {{SECURITY_SCORE}}/10

---

### 3. Architecture Review

**Agent:** general-purpose
**Status:** {{ARCHITECTURE_STATUS}}

#### Findings

{{ARCHITECTURE_FINDINGS}}

#### Recommendations

{{ARCHITECTURE_RECOMMENDATIONS}}

#### Score: {{ARCHITECTURE_SCORE}}/10

---

### 4. Performance Analysis

**Agent:** general-purpose
**Status:** {{PERFORMANCE_STATUS}}

#### Findings

{{PERFORMANCE_FINDINGS}}

#### Bottlenecks Identified

{{PERFORMANCE_BOTTLENECKS}}

#### Recommendations

{{PERFORMANCE_RECOMMENDATIONS}}

#### Score: {{PERFORMANCE_SCORE}}/10

---

### 5. Test Coverage Assessment

**Agent:** test-writer-fixer
**Status:** {{TESTING_STATUS}}

#### Findings

{{TESTING_FINDINGS}}

#### Coverage Metrics

{{TESTING_METRICS}}

#### Recommendations

{{TESTING_RECOMMENDATIONS}}

#### Score: {{TESTING_SCORE}}/10

{{TDD_DETAILED_EXISTS}}

## Conclusion

### Overall Assessment

{{OVERALL_ASSESSMENT}}

### Merge Readiness

{{MERGE_READINESS}}

### Next Steps

1. {{NEXT_STEP_1}}
2. {{NEXT_STEP_2}}
3. {{NEXT_STEP_3}}

### Final Score

{{FINAL_SCORE}}/10

---

**Report Generated:** {{TIMESTAMP}}
**Review Methodology:** Multi-agent parallel review
**Confidence Level:** {{CONFIDENCE}}
