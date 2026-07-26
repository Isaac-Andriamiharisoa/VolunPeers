# Navbar SCSS BEM Refactor Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Replace full class names nested inside `.app-navbar { }` with `&__element` shorthand and remove the dead `.app-navbar__link.active` rule.

**Architecture:** Single-file SCSS edit. All property values are preserved. The compiled CSS output is semantically identical — same selectors, same specificity — with one exception noted below.

**Tech Stack:** Rails 7.1, Sprockets, sassc-rails (SCSS)

---

## File Map

| Action | File |
|--------|------|
| Modify | `app/assets/stylesheets/components/_navbar.scss` |

---

### Task 1: Refactor `_navbar.scss` to BEM `&` shorthand

**Files:**
- Modify: `app/assets/stylesheets/components/_navbar.scss`

**Note on `&__start`:** The current file nests `.app-navbar__start { width: 100%; height: 100% }` _inside_ `.app-navbar__start-link { }`. In the DOM, `.app-navbar__start` is the **parent** of `.app-navbar__start-link`, so that selector (`.app-navbar .app-navbar__start-link .app-navbar__start`) never matches — it is dead code. The correct BEM placement is at block level. This task lifts it there, which is the only compiled-output difference from the original.

- [ ] **Step 1: Replace the file contents**

Write the following as the complete new content of `app/assets/stylesheets/components/_navbar.scss`:

```scss
.app-navbar {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 10px 20px;
  background-color: $primary-color;

  &__start-link {
    display: flex;
    justify-content: center;
    align-items: center;
    max-width: 40px;
    max-height: 40px;
  }

  &__start {
    width: 100%;
    height: 100%;
  }

  &__content {
    flex: 1;
    display: flex;
    justify-content: center;
    align-items: center;
  }

  &__links {
    display: flex;
    justify-content: center;
    align-items: center;
    color: $primary-color;
  }

  &__link {
    list-style: none;
    color: white;
    margin: 0 10px;
    padding: 0;
  }

  &__logo {
    width: 50px;
    height: 50px;
  }

  &__actions {
    display: flex;
    justify-content: space-between;
    align-items: center;
  }

  &__action {
    display: flex;
    justify-content: center;
    flex: 1 0 auto;
  }
}
```

- [ ] **Step 2: Verify SCSS compiles without errors**

```bash
cd /home/isaac/VolunPeers && bundle exec rails assets:precompile 2>&1 | tail -5
```

Expected: no errors. If you see `Undefined variable`, check that `config/variables` is imported before `bootstrap` in `application.scss`.

Clean up after:

```bash
bundle exec rails assets:clobber
```

Expected: `Removed /home/isaac/VolunPeers/public/assets`

- [ ] **Step 3: Commit**

```bash
git add app/assets/stylesheets/components/_navbar.scss
git commit -m "refactor: convert navbar SCSS to BEM & shorthand, drop dead .active rule"
```
