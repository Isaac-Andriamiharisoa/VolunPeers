import { Controller } from "@hotwired/stimulus"

// Highlights the clicked sidebar conversation immediately, since the sidebar
// lives outside the "conversation" Turbo Frame and isn't re-rendered on switch.
export default class extends Controller {
  select(event) {
    this.element
      .querySelectorAll(".chatroom__list-item--active")
      .forEach(item => item.classList.remove("chatroom__list-item--active"))
    event.currentTarget.classList.add("chatroom__list-item--active")
  }
}
