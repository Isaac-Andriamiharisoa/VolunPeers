# Centralized Stylesheet Variables Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Introduce `_sizes.scss` for normalized design tokens and `_variables.scss` as a single import entry point for all stylesheet config.

**Architecture:** Create two new files under `app/assets/stylesheets/config/`. The existing three config files are untouched except for `_bootstrap_variables.scss` which replaces raw `2px` values with the new `$radius-sm` token. `application.scss` swaps three imports for one.

**Tech Stack:** Rails 7.1, Sprockets, sassc-rails (SCSS)

---

## File Map

| Action | File |
|--------|------|
| Create | `app/assets/stylesheets/config/_sizes.scss` |
| Create | `app/assets/stylesheets/config/_variables.scss` |
| Modify | `app/assets/stylesheets/config/_bootstrap_variables.scss` |
| Modify | `app/assets/stylesheets/application.scss` |

---

### Task 1: Create `_sizes.scss`

**Files:**
- Create: `app/assets/stylesheets/config/_sizes.scss`

- [ ] **Step 1: Create the file with all three token groups**

```scss
// Spacing — covers the 5/10/20/30/50/100px pattern used across components
$space-xs:  5px;
$space-sm:  10px;
$space-md:  20px;
$space-lg:  30px;
$space-xl:  50px;
$space-2xl: 100px;

// Typography — covers every font-size in use (12, 14, 16, 18, 20, 36px)
$text-xs:   12px;
$text-sm:   14px;
$text-base: 1rem;
$text-md:   18px;
$text-lg:   20px;
$text-2xl:  36px;

// Border radius — 5px most common; 2/8/20px and 50% also present
$radius-sm:   2px;
$radius-md:   5px;
$radius-lg:   8px;
$radius-xl:   20px;
$radius-full: 50%;
```

Save to `app/assets/stylesheets/config/_sizes.scss`.

- [ ] **Step 2: Commit**

```bash
git add app/assets/stylesheets/config/_sizes.scss
git commit -m "feat: add _sizes.scss with spacing, typography, and radius tokens"
```

---

### Task 2: Create `_variables.scss` aggregator

**Files:**
- Create: `app/assets/stylesheets/config/_variables.scss`

- [ ] **Step 1: Create the aggregator file**

Import order matters: `colors` and `fonts` must precede `bootstrap_variables` (it references `$body-font`, `$headers-font`, and color vars). `sizes` must precede `bootstrap_variables` so it can reference `$radius-sm`.

```scss
@import "colors";
@import "fonts";
@import "sizes";
@import "bootstrap_variables";
```

Save to `app/assets/stylesheets/config/_variables.scss`.

- [ ] **Step 2: Commit**

```bash
git add app/assets/stylesheets/config/_variables.scss
git commit -m "feat: add _variables.scss as single config entry point"
```

---

### Task 3: Wire `$radius-sm` into Bootstrap overrides

**Files:**
- Modify: `app/assets/stylesheets/config/_bootstrap_variables.scss`

- [ ] **Step 1: Replace raw `2px` values with the token**

Current content of the radius section (lines 22–24):
```scss
$border-radius:    2px;
$border-radius-lg: 2px;
$border-radius-sm: 2px;
```

Replace with:
```scss
$border-radius:    $radius-sm;
$border-radius-lg: $radius-sm;
$border-radius-sm: $radius-sm;
```

`$radius-sm` is defined in `_sizes.scss`, which is imported before this file in `_variables.scss`, so the variable will be in scope.

- [ ] **Step 2: Commit**

```bash
git add app/assets/stylesheets/config/_bootstrap_variables.scss
git commit -m "refactor: use \$radius-sm token in bootstrap_variables"
```

---

### Task 4: Update `application.scss` to use the single entry point

**Files:**
- Modify: `app/assets/stylesheets/application.scss`

- [ ] **Step 1: Replace the three config imports with one**

Current lines 1–4:
```scss
// Graphical variables
@import "config/fonts";
@import "config/colors";
@import "config/bootstrap_variables";
```

Replace with:
```scss
// Graphical variables
@import "config/variables";
```

The rest of the file is unchanged:
```scss
// External libraries
@import "bootstrap";
@import "font-awesome";

// Your CSS partials
@import "components/index";
@import "pages/index";

* {
  margin: 0;
  padding: 0;
}

a {
  text-decoration: none;
}

body {
  min-height: 100vh;
  background-color: white;
  display: flex;
  flex-direction: column;
}
```

- [ ] **Step 2: Verify SCSS compiles without errors**

```bash
cd /home/isaac/VolunPeers && bundle exec rails assets:precompile 2>&1 | tail -5
```

Expected: no errors. If you see `Undefined variable` — check that `_sizes.scss` exists and that `_variables.scss` imports it before `bootstrap_variables`.

After confirming it compiles, clean up the precompiled output so development uses live compilation:

```bash
bundle exec rails assets:clobber
```

- [ ] **Step 3: Start the server and verify visually**

```bash
bin/rails server
```

Open the app in a browser. Confirm:
- The navbar renders with correct layout and sizing
- Bootstrap components (buttons, cards, dropdowns) render with the same `2px` border-radius as before
- No visual regressions on any page

- [ ] **Step 4: Commit**

```bash
git add app/assets/stylesheets/application.scss
git commit -m "refactor: replace individual config imports with config/variables entry point"
```
