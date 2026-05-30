# Mobile Sidebar Navigation Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add a slide-in sidebar for mobile navigation with active page indication, leaving the desktop navbar completely unchanged.

**Architecture:** A Stimulus controller (`sidebar`) mounted on `<body>` toggles CSS classes on a fixed sidebar panel and overlay. The existing desktop navbar is wrapped in `.app-navbar__desktop` and hidden on mobile via a media query. A new mobile top bar (hamburger + logo + avatar) and a separate sidebar partial replace it below 768px.

**Tech Stack:** Rails 7.1, Slim templates, Stimulus (importmap, eager-loaded), Bootstrap 5.2 (dropdowns), SCSS (Sprockets + sassc-rails), `$space-*` / `$text-*` / `$radius-*` tokens from `_sizes.scss`

---

## File Map

| Action | File |
|--------|------|
| Create | `app/javascript/controllers/sidebar_controller.js` |
| Append | `app/assets/stylesheets/components/_navbar.scss` |
| Create | `app/views/shared/_sidebar.html.slim` |
| Modify | `app/views/shared/_navbar.html.slim` |
| Modify | `app/views/layouts/application.html.slim` |

Tasks 1–4 are independently committable. Task 5 is the final wiring — the feature becomes visible in the browser only after all five tasks are complete.

---

### Task 1: Stimulus sidebar controller

**Files:**
- Create: `app/javascript/controllers/sidebar_controller.js`

The project uses `eagerLoadControllersFrom` in `app/javascript/controllers/index.js`, so any `*_controller.js` file dropped into that directory is automatically registered. No importmap change needed.

- [ ] **Step 1: Create the controller**

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

Save to `app/javascript/controllers/sidebar_controller.js`.

- [ ] **Step 2: Commit**

```bash
git add app/javascript/controllers/sidebar_controller.js
git commit -m "feat: add sidebar Stimulus controller"
```

---

### Task 2: Mobile SCSS additions

**Files:**
- Modify: `app/assets/stylesheets/components/_navbar.scss` (append only — do not touch existing rules)

All `$space-*`, `$text-*`, and `$radius-*` tokens are defined in `app/assets/stylesheets/config/_sizes.scss` and are in scope via `_variables.scss`.

- [ ] **Step 1: Append the mobile block to the end of `_navbar.scss`**

Add the following after the closing `}` of the existing `.app-navbar { }` block:

```scss
// --- Mobile sidebar & overlay (always in DOM, off-screen/hidden by default) ---

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
  clear: both;
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

// --- Mobile top bar (hidden on desktop) ---

.app-navbar__mobile-bar {
  display: none;
}

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

.app-navbar__mobile-actions {
  display: flex;
  align-items: center;
}

.app-navbar__mobile-login {
  color: white;
  font-size: $text-sm;
}

// --- Responsive breakpoint ---

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
```

- [ ] **Step 2: Verify SCSS compiles**

```bash
cd /home/isaac/VolunPeers && bundle exec rails assets:precompile 2>&1 | tail -5
```

Expected: no errors. Clean up:

```bash
bundle exec rails assets:clobber
```

Expected: `Removed /home/isaac/VolunPeers/public/assets`

- [ ] **Step 3: Commit**

```bash
git add app/assets/stylesheets/components/_navbar.scss
git commit -m "feat: add mobile sidebar and top bar SCSS"
```

---

### Task 3: Sidebar partial

**Files:**
- Create: `app/views/shared/_sidebar.html.slim`

This partial renders the slide-in panel. `current_page?` is a Rails view helper — it returns `true` when the current request path matches the given route. The `data-sidebar-target="sidebar"` attribute connects this element to the Stimulus controller defined in Task 1.

- [ ] **Step 1: Create the partial**

```slim
.app-navbar__sidebar data-sidebar-target="sidebar"
  button.app-navbar__sidebar-close data-action="click->sidebar#close"
    | ×
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

Save to `app/views/shared/_sidebar.html.slim`.

- [ ] **Step 2: Commit**

```bash
git add app/views/shared/_sidebar.html.slim
git commit -m "feat: add sidebar partial with active page detection"
```

---

### Task 4: Update navbar partial

**Files:**
- Modify: `app/views/shared/_navbar.html.slim`

Wrap the existing three desktop zones (`__start`, `__content`, `__actions`) inside a new `.app-navbar__desktop` div. Add a `.app-navbar__mobile-bar` div alongside it. The desktop structure is untouched — only wrapped.

- [ ] **Step 1: Replace the full file contents**

```slim
.app-navbar
  .app-navbar__desktop
    .app-navbar__start
      = link_to root_path, class: "app-navbar__start-link" do
        = inline_svg("logo", class: "app-navbar__logo")

      button.navbar-toggler type="button" data-bs-toggle="collapse" data-bs-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation"
        span.navbar-toggler-icon

    .app-navbar__content
      .app-navbar__links
        - if user_signed_in?
          - signed_in_links.each do |link, path|
            = link_to link, path, class: "app-navbar__link"

        - else
          - signed_out_links.each do |link, path|
            = link_to link, path, class: "app-navbar__link"

    .app-navbar__actions
      - if user_signed_in?
        .app-navbar__action.dropdown
          - if current_user.photo.attached?
            a.avatar-bordered#navbarDropdown href="#" data-bs-toggle="dropdown" aria-haspopup="true" aria-expanded="false" style="background-image: url('#{current_user.photo.url}');"
          - else
            a.avatar-bordered#navbarDropdown href="#" data-bs-toggle="dropdown" aria-haspopup="true" aria-expanded="false" style="background-image: url('#{asset_path('placeholder-image.png')}');"

          .dropdown-menu.dropdown-menu-end aria-labelledby="navbarDropdown"
            = link_to "Dashboard", dashboard_path, class: "dropdown-item"
            = link_to "Add a cause", new_event_path, class: "dropdown-item"
            = link_to "Edit profile", edit_user_registration_path, class: "dropdown-item"
            = link_to "Log out", destroy_user_session_path, data: {turbo_method: :delete}, class: "dropdown-item"
      - else
        .app-navbar__action
          = link_to "Login", new_user_session_path

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
          a.avatar-bordered#mobileNavDropdown href="#" data-bs-toggle="dropdown" aria-haspopup="true" aria-expanded="false" style="background-image: url('#{current_user.photo.url}');"
        - else
          a.avatar-bordered#mobileNavDropdown href="#" data-bs-toggle="dropdown" aria-haspopup="true" aria-expanded="false" style="background-image: url('#{asset_path('placeholder-image.png')}');"

        .dropdown-menu.dropdown-menu-end aria-labelledby="mobileNavDropdown"
          = link_to "Dashboard", dashboard_path, class: "dropdown-item"
          = link_to "Add a cause", new_event_path, class: "dropdown-item"
          = link_to "Edit profile", edit_user_registration_path, class: "dropdown-item"
          = link_to "Log out", destroy_user_session_path, data: {turbo_method: :delete}, class: "dropdown-item"
    - else
      = link_to "Login", new_user_session_path, class: "app-navbar__mobile-login"
```

- [ ] **Step 2: Commit**

```bash
git add app/views/shared/_navbar.html.slim
git commit -m "feat: wrap desktop nav, add mobile top bar to navbar partial"
```

---

### Task 5: Wire layout — connect Stimulus controller, sidebar, and overlay

**Files:**
- Modify: `app/views/layouts/application.html.slim`

This is the final wiring step. Adding `data-controller="sidebar"` to `<body>` mounts the Stimulus controller across all pages. The sidebar partial (Task 3) and overlay `div` must be siblings inside `<body>` so Stimulus can reach them as targets.

- [ ] **Step 1: Replace the body section of the layout**

The `head` block is unchanged. Only the `body` line and its children change.

Replace lines 32–37 of `app/views/layouts/application.html.slim`:

```slim
  body data-controller="sidebar"
    = render "shared/navbar"
    = render "shared/sidebar"
    .app-navbar__overlay data-sidebar-target="overlay" data-action="click->sidebar#close"
    = render "shared/flashes"
    = yield
    - unless @hide_footer
      = render "shared/footer"
```

- [ ] **Step 2: Start the server and verify end-to-end**

```bash
cd /home/isaac/VolunPeers && bin/rails server
```

Open the app in a browser. Verify:

**Desktop (> 768px wide):**
- Navbar renders the horizontal logo + links + avatar layout as before
- No mobile bar visible

**Mobile (resize browser to < 768px or use DevTools device mode):**
- Only the mobile top bar is visible: hamburger on left, logo in centre, avatar on right
- Tapping hamburger slides in the sidebar from the left
- Current page link is bold with a white left border
- Tapping the overlay or × closes the sidebar
- Page does not scroll while sidebar is open

- [ ] **Step 3: Commit**

```bash
git add app/views/layouts/application.html.slim
git commit -m "feat: wire sidebar controller and overlay in layout"
```
