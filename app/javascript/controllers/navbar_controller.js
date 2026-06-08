import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["dropdown", "overlay"]

  connect() {
    this._onBeforeCache = () => this.close()
    document.addEventListener("turbo:before-cache", this._onBeforeCache)
  }

  open() {
    this.dropdownTarget.classList.add("app-navbar__nav-dropdown--open")
    this.overlayTarget.classList.add("app-navbar__overlay--visible")
    document.body.style.overflow = "hidden"
  }

  close() {
    this.dropdownTarget.classList.remove("app-navbar__nav-dropdown--open")
    this.overlayTarget.classList.remove("app-navbar__overlay--visible")
    document.body.style.overflow = ""
  }

  disconnect() {
    document.removeEventListener("turbo:before-cache", this._onBeforeCache)
    this.close()
  }
}
