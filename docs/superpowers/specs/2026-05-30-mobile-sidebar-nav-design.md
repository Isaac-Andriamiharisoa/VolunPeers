# Mobile Sidebar Navigation

**Date:** 2026-05-30
**Project:** VolunPeers

## Goal

Add a mobile-responsive navigation to the existing navbar. Below 768px the desktop nav hides and a mobile top bar + slide-in sidebar takes over, with active page indication on sidebar links.

## Current State

The navbar (`app/views/shared/_navbar.html.slim`, styled via `app/assets/stylesheets/components/_navbar.scss`) is a horizontal flexbox with three zones: logo, links, avatar. It has no responsive behaviour — on small screens the layout breaks.

## Behaviour

### Desktop (≥ 768px)
No change. The existing `.app-navbar` layout renders as before.

### Mobile (< 768px)

**Top bar** — replaces the desktop navbar. Three-column flex layout:
- Left: hamburger button (three lines) — opens the sidebar
- Center: logo (SVG, same as desktop)
- Right: avatar with Bootstrap dropdown (same actions as desktop) for signed-in users; "Login" link for signed-out users

**Sidebar** — fixed, full-height panel slides in from the left on hamburger tap:
- Width: 75% of viewport, max 280px
- Dark green background (`$primary-color`) matching the top bar
- Nav links listed vertically: Home, Causes, Agenda, Chatrooms, About us (signed-in); Home, Causes, About us (signed-out)
- Active page link: left border (`3px solid white`) + bold weight + full opacity. Inactive links at 80% opacity.
- Close button (×) in the top-right corner of the sidebar

**Overlay** — fixed full-screen semi-transparent black layer sits between the sidebar and the page content. Tapping it closes the sidebar.

**Scroll lock** — while the sidebar is open, `document.body.style.overflow = "hidden"` prevents the page behind from scrolling.

## Active Page Detection

Rails' `current_page?` helper adds the `app-navbar__sidebar-link--active` BEM modifier:

```slim
= link_to "Home", root_path,
    class: "app-navbar__sidebar-link #{current_page?(root_path) ? 'app-navbar__sidebar-link--active' : ''}"
```

## JavaScript

New Stimulus controller `sidebar` (`app/javascript/controllers/sidebar_controller.js`). Auto-loaded by the existing `eagerLoadControllersFrom` in `controllers/index.js` — no importmap changes needed.

```js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["sidebar", "overlay"]

  open() {
    this.sidebarTarget.classList.add("app-navbar__sidebar--open")
    this.overlayTarget.classList.add("app-navbar__overlay--visible")
    document.body.style.overflow = "hidden"
  }

  close() {
    this.sidebarTarget.classList.remove("app-navbar__sidebar--open")
    this.overlayTarget.classList.remove("app-navbar__overlay--visible")
    document.body.style.overflow = ""
  }
}
```

`data-controller="sidebar"` lives on the `<body>` tag in `app/views/layouts/application.html.slim`. The sidebar and overlay elements are direct children of `<body>` (outside the navbar partial) so Stimulus can target them from the controller scope.

## Template Structure

### `app/views/layouts/application.html.slim`

Add `data-controller="sidebar"` to the `<body>` tag, and render two new partials before `yield`:

```slim
body data-controller="sidebar"
  = render "shared/navbar"
  = render "shared/sidebar"      ← new
  .app-navbar__overlay data-sidebar-target="overlay" data-action="click->sidebar#close"
  = render "shared/flashes"
  = yield
```

### `app/views/shared/_navbar.html.slim`

The existing desktop structure is wrapped in `.app-navbar__desktop` (hidden on mobile). A new `.app-navbar__mobile-bar` sits alongside it (hidden on desktop):

```slim
.app-navbar
  .app-navbar__desktop
    / ... existing start / content / actions unchanged ...

  .app-navbar__mobile-bar
    button.app-navbar__hamburger data-action="click->sidebar#open"
      span
      span
      span
    = link_to root_path, class: "app-navbar__mobile-logo" do
      = inline_svg("logo", class: "app-navbar__logo")
    - if user_signed_in?
      .app-navbar__mobile-actions.dropdown
        - if current_user.photo.attached?
          a.avatar-bordered#mobileNavDropdown href="#" data-bs-toggle="dropdown" ...
        - else
          a.avatar-bordered#mobileNavDropdown href="#" data-bs-toggle="dropdown" ...
        .dropdown-menu.dropdown-menu-end aria-labelledby="mobileNavDropdown"
          = link_to "Dashboard", dashboard_path, class: "dropdown-item"
          = link_to "Add a cause", new_event_path, class: "dropdown-item"
          = link_to "Edit profile", edit_user_registration_path, class: "dropdown-item"
          = link_to "Log out", destroy_user_session_path, data: {turbo_method: :delete}, class: "dropdown-item"
    - else
      = link_to "Login", new_user_session_path, class: "app-navbar__mobile-login"
```

### `app/views/shared/_sidebar.html.slim` (new)

```slim
.app-navbar__sidebar data-sidebar-target="sidebar"
  button.app-navbar__sidebar-close data-action="click->sidebar#close" ×
  nav.app-navbar__sidebar-nav
    - if user_signed_in?
      = link_to "Home", root_path, class: "app-navbar__sidebar-link #{current_page?(root_path) ? 'app-navbar__sidebar-link--active' : ''}"
      = link_to "Causes", events_path, class: "app-navbar__sidebar-link #{current_page?(events_path) ? 'app-navbar__sidebar-link--active' : ''}"
      = link_to "Agenda", calendar_path, class: "app-navbar__sidebar-link #{current_page?(calendar_path) ? 'app-navbar__sidebar-link--active' : ''}"
      = link_to "Chatrooms", chatrooms_path, class: "app-navbar__sidebar-link #{current_page?(chatrooms_path) ? 'app-navbar__sidebar-link--active' : ''}"
      = link_to "About us", about_path, class: "app-navbar__sidebar-link #{current_page?(about_path) ? 'app-navbar__sidebar-link--active' : ''}"
    - else
      = link_to "Home", root_path, class: "app-navbar__sidebar-link #{current_page?(root_path) ? 'app-navbar__sidebar-link--active' : ''}"
      = link_to "Causes", events_path, class: "app-navbar__sidebar-link #{current_page?(events_path) ? 'app-navbar__sidebar-link--active' : ''}"
      = link_to "About us", about_path, class: "app-navbar__sidebar-link #{current_page?(about_path) ? 'app-navbar__sidebar-link--active' : ''}"
```

## SCSS Additions

New mobile block appended to `_navbar.scss`. No existing rules change.

```scss
// Mobile top bar
.app-navbar__mobile-bar {
  display: none;
}

// Sidebar + overlay (always in DOM, hidden by default)
.app-navbar__sidebar {
  position: fixed;
  top: 0;
  left: 0;
  height: 100%;
  width: 75%;
  max-width: 280px;
  background-color: $primary-color;
  transform: translateX(-100%);
  transition: transform 0.25s ease;
  z-index: 1050;
  padding: $space-md;

  &--open {
    transform: translateX(0);
  }
}

.app-navbar__overlay {
  display: none;
  position: fixed;
  inset: 0;
  background: rgba(0, 0, 0, 0.45);
  z-index: 1040;

  &--visible {
    display: block;
  }
}

.app-navbar__sidebar-close {
  background: none;
  border: none;
  color: white;
  font-size: $text-lg;
  cursor: pointer;
  float: right;
  margin-bottom: $space-sm;
}

.app-navbar__sidebar-nav {
  display: flex;
  flex-direction: column;
  margin-top: $space-md;
}

.app-navbar__sidebar-link {
  color: rgba(255, 255, 255, 0.8);
  padding: $space-sm $space-xs;
  border-left: 3px solid transparent;
  text-decoration: none;
  font-size: $text-md;

  &--active {
    color: white;
    font-weight: bold;
    border-left-color: white;
  }
}

// Mobile media query
@media (max-width: 767px) {
  .app-navbar__desktop {
    display: none;
  }

  .app-navbar__mobile-bar {
    display: flex;
    align-items: center;
    justify-content: space-between;
    width: 100%;
    padding: $space-xs $space-sm;
  }
}

// Hamburger button
.app-navbar__hamburger {
  background: none;
  border: none;
  cursor: pointer;
  display: flex;
  flex-direction: column;
  gap: 5px;
  padding: $space-xs;

  span {
    display: block;
    width: 22px;
    height: 2px;
    background: white;
    border-radius: $radius-sm;
  }
}

.app-navbar__mobile-logo {
  display: flex;
  align-items: center;
}

.app-navbar__mobile-login {
  color: white;
  font-size: $text-sm;
}
```

## Files Touched

| File | Action |
|------|--------|
| `app/views/layouts/application.html.slim` | Add `data-controller="sidebar"` to body, render sidebar partial and overlay |
| `app/views/shared/_navbar.html.slim` | Wrap desktop nav in `.app-navbar__desktop`, add `.app-navbar__mobile-bar` |
| `app/views/shared/_sidebar.html.slim` | Create — sidebar panel with nav links and active detection |
| `app/assets/stylesheets/components/_navbar.scss` | Append mobile SCSS block |
| `app/javascript/controllers/sidebar_controller.js` | Create — Stimulus open/close controller |

## What is NOT in Scope

- Changing any desktop layout or styles
- Animations beyond the CSS `transform` slide
- Keyboard / accessibility enhancements (ARIA) — follow-on work
