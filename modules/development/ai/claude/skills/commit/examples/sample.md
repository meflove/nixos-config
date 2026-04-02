# Sample Commit Output

## Context

**Git Status:**
```
On branch main
Your branch is up to date with 'origin/main'.

Changes to be committed:
  modified:   modules/desktop/wm/hyprland/default.nix
  modified:   modules/desktop/wm/hyprland/settings.nix
```

**Git Diff:**
```diff
diff --git a/modules/desktop/wm/hyprland/default.nix b/modules/desktop/wm/hyprland/default.nix
index 1234567..abcdefg 100644
--- a/modules/desktop/wm/hyprland/default.nix
+++ b/modules/desktop/wm/hyprland/default.nix
@@ -10,7 +10,7 @@ {
   hm.wayland.windowManager.hyprland = {
     enable = true;
     settings = {
-      gaps_in = 5;
+      gaps_in = 8;
       gaps_out = 20;
     };
   };
```

## Proposed Commit Message

```
🎨 style(hyprland): increase inner gaps for better spacing

- Adjust gaps_in from 5 to 8 for improved window spacing
- Maintain consistent visual hierarchy with gaps_out
```

## Analysis

### Changed Files
- `modules/desktop/wm/hyprland/default.nix` - modified gap settings
- `modules/desktop/wm/hyprland/settings.nix` - no functional changes

### Change Type
**Type:** `style` (🎨)
**Reason:** This is a pure formatting/visual change that doesn't affect logic or behavior

### Scope
**Scope:** `(hyprland)`
**Reason:** Changes are specific to Hyprland window manager configuration

### Description
"increase inner gaps for better spacing" - 38 characters, lowercase, no period

### Bullet Points
- **WHY:** Improve visual spacing between windows for better aesthetics
- **WHAT:** Changed gaps_in value from 5 to 8
- **CONTEXT:** Maintains proportional relationship with gaps_out (20)

## Convention Checklist
- [x] Title ≤ 50 characters: ✅ (38 chars)
- [x] Type matches change: ✅ (style for formatting)
- [x] Scope appropriate: ✅ (hyprland-specific)
- [x] Bullet points explain WHY: ✅ (focuses on improved aesthetics)
- [x] Grammar and spelling: ✅

---
*This commit message follows Conventional Commits format with emoji prefix*
