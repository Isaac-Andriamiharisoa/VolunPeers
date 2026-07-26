# Navbar SCSS BEM Refactor

**Date:** 2026-05-30
**Project:** VolunPeers

## Goal

Refactor `_navbar.scss` to follow BEM conventions: replace full class names nested inside the block with `&__element` shorthand, and remove the dead `.active` modifier.

## Current State

`app/assets/stylesheets/components/_navbar.scss` has two BEM violations:

1. **Nesting style**: Elements use full class names nested inside the block:
   ```scss
   .app-navbar {
     .app-navbar__start-link { ... }  // ← not BEM SCSS convention
   }
   ```
   This compiles to `.app-navbar .app-navbar__start-link` — a descendant selector — which adds unneeded specificity and hides the BEM structure.

2. **Dead modifier**: `.app-navbar__link.active` uses a compound class instead of BEM's `--modifier` syntax, and is not applied anywhere in the template.

## Change

**File:** `app/assets/stylesheets/components/_navbar.scss`

Replace all nested full-class selectors with `&__element` shorthand inside `.app-navbar { }`. Remove `.app-navbar__link.active` entirely.

### Before → After (structure only, values unchanged)

```scss
// Before
.app-navbar {
  .app-navbar__start-link { ... }
  .app-navbar__content { ... }
  .app-navbar__links { ... }
  .app-navbar__link { ... }
  .app-navbar__link.active { ... }   // ← dead code, drop
  .app-navbar__logo { ... }
  .app-navbar__actions { ... }
  .app-navbar__action { ... }
}

// After
.app-navbar {
  &__start-link { ... }
  &__content { ... }
  &__links { ... }
  &__link { ... }
  // .active rule removed
  &__logo { ... }
  &__actions { ... }
  &__action { ... }
}
```

All property values, variables, and layout rules are preserved exactly. The compiled CSS output is identical (same selectors, same specificity).

## What is NOT in Scope

- Changes to `_navbar.html.slim` — no class names change
- Converting `.active` to `--active` and wiring it in the template — dropped as dead code
- Any visual changes

## Files Touched

| File | Action |
|------|--------|
| `app/assets/stylesheets/components/_navbar.scss` | Refactor |
