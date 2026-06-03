# Mobile Navbar Redesign

**Date:** 2026-06-03
**Project:** VolunPeers

## Goal

Redesign the mobile navbar to: logo (left, smaller) | hamburger (center) | avatar+dropdown (right, same size as logo). The hamburger opens a full-width top dropdown (~50vh) for nav links. The left-side slide-in sidebar is removed entirely.

## Files Changed

| File | Action |
|------|--------|
| `app/views/shared/_navbar.html.slim` | Reorder mobile bar, add dropdown panel |
| `app/views/shared/_sidebar.html.slim` | Delete |
| `app/views/layouts/application.html.slim` | Remove sidebar render, update controller name |
| `app/javascript/controllers/sidebar_controller.js` | Rename → `navbar_controller.js`, update targets |
| `app/assets/stylesheets/components/_navbar.scss` | Remove sidebar SCSS, add dropdown SCSS, resize mobile logo/avatar |

## Section 1 — Mobile Bar HTML

`.app-navbar__mobile-bar` DOM order: **logo → hamburger → avatar**.

- Logo: `app-navbar__mobile-logo` link wrapping `app-navbar__logo app-navbar__logo--mobile`
- Hamburger: `app-navbar__hamburger` button with `data-action="click->navbar#open"`
- Avatar: existing dropdown markup (unchanged, avatar size controlled by CSS)

The top dropdown panel `.app-navbar__nav-dropdown` is a third child of `.app-navbar` (sibling of `__desktop` and `__mobile-bar`):

```slim
.app-navbar__nav-dropdown data-navbar-target="dropdown"
  nav.app-navbar__nav-dropdown-nav
    - (user_signed_in? ? signed_in_links : signed_out_links).each do |label, path|
      = link_to label, path, class: class_names("app-navbar__nav-dropdown-link", "app-navbar__nav-dropdown-link--active" => current_page?(path))
```

Overlay stays in `application.html.slim` with `data-navbar-target="overlay"`.

## Section 2 — CSS

**Mobile bar:** `display: flex; justify-content: space-between` — DOM order handles positioning. No explicit `order` needed.

**Mobile logo + avatar sizing:** Both `28px × 28px`. Desktop logo stays `50px × 50px`.

```scss
&__logo {
  width: 50px;
  height: 50px;

  &--mobile {
    width: 28px;
    height: 28px;
  }
}
```

Avatar in mobile context: `width: 28px; height: 28px` via `.app-navbar__mobile-bar .avatar-bordered`.

**Top dropdown:**

```scss
.app-navbar__nav-dropdown {
  position: fixed;
  top: 60px; /* adjust to match rendered mobile bar height */
  left: 0;
  width: 100%;
  height: 50vh;
  background-color: $primary-color;
  transform: translateY(-110%);
  transition: transform 0.25s ease;
  z-index: 1060;
  display: flex;
  align-items: center;
  justify-content: center;

  &--open {
    transform: translateY(0);
  }
}

.app-navbar__nav-dropdown-nav {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: $space-lg;
}

.app-navbar__nav-dropdown-link {
  color: rgba(255, 255, 255, 0.8);
  font-size: $text-lg;
  text-decoration: none;

  &--active {
    color: white;
    font-weight: bold;
    border-bottom: 2px solid white;
    padding-bottom: 2px;
  }
}
```

Old sidebar SCSS blocks removed: `.app-navbar__sidebar`, `__sidebar-close`, `__sidebar-nav`, `__sidebar-link`.

`@media (max-width: 767px)` block unchanged — still hides `__desktop`, shows `__mobile-bar`.

## Section 3 — Stimulus Controller

`sidebar_controller.js` → `navbar_controller.js`:

- `static targets = ["dropdown", "overlay"]`
- `open()`: add `app-navbar__nav-dropdown--open` to `dropdownTarget`, add `app-navbar__overlay--visible` to `overlayTarget`, lock scroll
- `close()`: remove both classes, unlock scroll
- Turbo cache guard and disconnect cleanup unchanged

`application.html.slim`:
- `body data-controller="navbar"`
- Remove `= render "shared/sidebar"`
- Overlay div: `data-navbar-target="overlay" data-action="click->navbar#close"`
