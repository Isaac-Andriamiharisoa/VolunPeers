import { Controller } from "@hotwired/stimulus"

// Handles the parts of the conversation Turbo Streams can't: aligning each
// bubble to its sender, inserting day separators, animating new arrivals,
// resetting the composer, and keeping the view scrolled to the latest message.
export default class extends Controller {
  static targets = ["list"]
  static values = { currentUserId: Number }

  connect() {
    this.decorateAll()
    this.observer = new MutationObserver(mutations => {
      let added = false
      mutations.forEach(mutation => {
        mutation.addedNodes.forEach(node => {
          if (node.nodeType === Node.ELEMENT_NODE && node.classList.contains("message")) {
            this.decorate(node, true)
            added = true
          }
        })
      })
      if (added) this.scrollToBottom()
    })
    this.observer.observe(this.listTarget, { childList: true })
    this.scrollToBottom()
  }

  disconnect() {
    this.observer?.disconnect()
  }

  decorateAll() {
    this.listTarget.querySelectorAll(".message").forEach(node => this.decorate(node, false))
  }

  decorate(node, isNew) {
    const mine = parseInt(node.dataset.userId, 10) === this.currentUserIdValue
    node.classList.add(mine ? "message--right" : "message--left")
    if (isNew) {
      node.classList.add("message--new")
      this.clearEmptyState()
    }
    this.ensureDaySeparator(node)
  }

  // Insert a centered date pill before the first message of each calendar day.
  ensureDaySeparator(node) {
    const label = this.dayLabel(new Date(node.dataset.createdAt))

    let previousMessage = node.previousElementSibling
    while (previousMessage && !previousMessage.classList.contains("message")) {
      previousMessage = previousMessage.previousElementSibling
    }
    if (previousMessage && this.dayLabel(new Date(previousMessage.dataset.createdAt)) === label) return

    const separator = document.createElement("div")
    separator.className = "messages__day"
    separator.dataset.day = label
    separator.textContent = label
    node.parentNode.insertBefore(separator, node)
  }

  dayLabel(date) {
    const today = new Date()
    const yesterday = new Date()
    yesterday.setDate(today.getDate() - 1)
    const sameDay = (a, b) => a.toDateString() === b.toDateString()
    if (sameDay(date, today)) return "Today"
    if (sameDay(date, yesterday)) return "Yesterday"
    return date.toLocaleDateString(undefined, { month: "long", day: "numeric" })
  }

  clearEmptyState() {
    this.listTarget.querySelector(".messages__empty")?.remove()
  }

  reset(event) {
    if (event.detail.success) event.target.reset()
  }

  scrollToBottom() {
    this.listTarget.scrollTop = this.listTarget.scrollHeight
  }
}
