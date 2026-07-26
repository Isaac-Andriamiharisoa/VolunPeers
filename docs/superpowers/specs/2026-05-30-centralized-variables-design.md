# Centralized Stylesheet Variables

**Date:** 2026-05-30
**Project:** VolunPeers

## Goal

Consolidate stylesheet configuration into a single entry point (`_variables.scss`) and introduce a sizing system (`_sizes.scss`) so all stylesheets share one normalized set of design tokens.

## Current State

Three separate config files exist under `app/assets/stylesheets/config/`:

| File | Contents |
|------|----------|
| `_colors.scss` | Color variables (`$primary-color`, `$red`, `$blue`, etc.) |
| `_fonts.scss` | Font-family variables (`$body-font`, `$headers-font`, `$title-font`) |
| `_bootstrap_variables.scss` | Bootstrap Sass overrides (colors, radius, card width) |

`application.scss` imports all three individually. No sizing tokens exist — components use raw px values throughout.

## Changes

### 1. New file: `config/_sizes.scss`

Defines three token groups derived from actual values found in component stylesheets.

**Spacing** (covers the 5/10/20/30/50/100px pattern used across components):
```scss
$space-xs:  5px;
$space-sm:  10px;
$space-md:  20px;
$space-lg:  30px;
$space-xl:  50px;
$space-2xl: 100px;
```

**Typography** (covers every font-size in use: 12, 14, 16, 18, 20, 36px):
```scss
$text-xs:   12px;
$text-sm:   14px;
$text-base: 1rem;
$text-md:   18px;
$text-lg:   20px;
$text-2xl:  36px;
```

**Border radius** (5px is most common; 2/8/20px and 50% also present):
```scss
$radius-sm:   2px;
$radius-md:   5px;
$radius-lg:   8px;
$radius-xl:   20px;
$radius-full: 50%;
```

Breakpoints and container widths are intentionally excluded: Bootstrap owns breakpoints natively, and the fixed widths found in components (486px, 535px, 720px) are component-specific, not general tokens.

### 2. New file: `config/_variables.scss`

Single entry-point that imports all config files in dependency order:

```scss
@import "colors";
@import "fonts";
@import "sizes";
@import "bootstrap_variables";
```

Individual files remain importable directly (`@import "config/colors"` still works). The aggregator is additive.

Import order is load-order-dependent: `colors` and `fonts` must precede `bootstrap_variables` (which references `$body-font`, `$headers-font`, and color variables). `sizes` must precede `bootstrap_variables` so it can reference `$radius-sm`.

### 3. Update: `config/_bootstrap_variables.scss`

Replace the three raw `2px` border-radius values with the new token:

```scss
// Before
$border-radius:    2px;
$border-radius-lg: 2px;
$border-radius-sm: 2px;

// After
$border-radius:    $radius-sm;
$border-radius-lg: $radius-sm;
$border-radius-sm: $radius-sm;
```

### 4. Update: `application.scss`

Replace three individual config imports with one:

```scss
// Before
@import "config/fonts";
@import "config/colors";
@import "config/bootstrap_variables";

// After
@import "config/variables";
```

## What is NOT in scope

- Replacing existing hardcoded values in component stylesheets with the new tokens. That is a follow-on refactor.
- Adding line-height, z-index, or shadow tokens.
- Changing any component behavior or visual output.

## Files Touched

| File | Action |
|------|--------|
| `app/assets/stylesheets/config/_sizes.scss` | Create |
| `app/assets/stylesheets/config/_variables.scss` | Create |
| `app/assets/stylesheets/config/_bootstrap_variables.scss` | Update (radius tokens) |
| `app/assets/stylesheets/application.scss` | Update (single import) |
