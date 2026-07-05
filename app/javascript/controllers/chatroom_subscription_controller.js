import { Controller } from "@hotwired/stimulus"
import { createConsumer } from "@rails/actioncable"
import moment from "moment"

// Connects to data-controller="chatroom-subscription"
export default class extends Controller {
  static values = {
    ids: String,
    currentUserId: Number
  }

  static targets = ["latestMessages", "latestMessage", "chatField", "timestamp"]

  connect() {
    this.chatrooms = this.idsValue.split(",")
    this.formatSidebarTimestamps()
    this.subscriptions = this.chatrooms.map((id, index) => this.subscribeToChatroom(id, index))

    this.currentChatroom = this.chatrooms[0]
    this.clearInactiveChatrooms()
    this.setActiveListItem()
    this.scrollActiveToBottom()
    this.formatDateTime()
  }

  subscribeToChatroom(id, index) {
    return createConsumer().subscriptions.create(
      { channel: "ChatroomChannel", id: parseInt(id, 10) },
      { received: data => this.appendIncomingMessage(data, index) }
    )
  }

  // Render a broadcast message into its chatroom and refresh the sidebar preview
  appendIncomingMessage(data, index) {
    const template = document.createElement("div")
    template.innerHTML = data

    const messageEl = template.querySelector(".message")
    if (messageEl) {
      const sentByCurrentUser = parseInt(messageEl.dataset.userId, 10) === this.currentUserIdValue
      messageEl.classList.add(sentByCurrentUser ? "message--right" : "message--left")
      messageEl.classList.add("message--new") // triggers the appear animation
    }

    // Append without rebuilding existing nodes, so only the new message animates
    this.latestMessagesTargets[index].insertAdjacentHTML("beforeend", template.innerHTML)
    this.updateSidebarPreview(index, data)

    this.chatFieldTargets[index].value = ""
    this.scrollChatToBottom(index)
    this.formatDateTime()
  }

  // Show the latest message's content and relative time in the sidebar list
  updateSidebarPreview(index, data) {
    const preview = this.latestMessageTargets[index]
    preview.innerHTML = data
    this.timestampTargets[index].innerHTML = moment(preview.querySelector("i").innerHTML).fromNow()
    preview.innerHTML = preview.querySelector("p").innerText
  }

  formatSidebarTimestamps() {
    this.timestampTargets.forEach(target => {
      target.innerHTML = moment(target.innerHTML).fromNow()
    })
  }

  formatDateTime() {
    document.querySelectorAll(".datetime").forEach(elem => {
      elem.innerHTML = moment(elem.dataset.originalDate).fromNow()
    })
  }

  // Scroll one chatroom's message list down to its latest message
  scrollChatToBottom(index) {
    const container = this.latestMessagesTargets[index]
    if (container) container.scrollTop = container.scrollHeight
  }

  // Scroll the visible chatroom(s) to the bottom once the layout is settled
  scrollActiveToBottom() {
    requestAnimationFrame(() => {
      this.latestMessagesTargets.forEach(container => {
        container.scrollTop = container.scrollHeight
      })
    })
  }

  // Show only the active conversation's column and hide the others
  clearInactiveChatrooms() {
    this.chatrooms.forEach(id => {
      const display = id === this.currentChatroom ? "block" : "none"
      document.querySelectorAll(`.event-${id}`).forEach(el => el.style.display = display)
    })
  }

  // Highlight the currently selected conversation in the sidebar list
  setActiveListItem() {
    document.querySelectorAll("li[data-chatroom-id]").forEach(li => {
      li.classList.toggle("active", li.dataset.chatroomId === this.currentChatroom)
    })
  }

  selectChat(event) {
    this.currentChatroom = event.target.closest("li").dataset.chatroomId
    this.clearInactiveChatrooms()
    this.setActiveListItem()
    this.scrollActiveToBottom()
  }

  deleteConversation(event) {
    if (!confirm("Are you sure you want to delete this conversation?")) return

    const chatroomId = event.currentTarget.dataset.chatroomId
    const url = `/chatrooms/${chatroomId}/delete_conversation?timestamp=${Date.now()}`

    fetch(url, {
      method: "DELETE",
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content
      }
    })
      .then(response => {
        if (!response.ok) {
          console.error("Error deleting conversation.")
          return
        }
        // Clear the deleted conversation's messages from the UI
        this.latestMessagesTargets.forEach((target, index) => {
          if (this.chatrooms[index] === chatroomId) target.innerHTML = ""
        })
      })
      .catch(error => console.error("Error:", error))
  }
}
