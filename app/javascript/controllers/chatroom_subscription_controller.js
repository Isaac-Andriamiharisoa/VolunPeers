import { Controller } from "@hotwired/stimulus"
import { createConsumer } from "@rails/actioncable"
import moment from "moment"

// Connects to data-controller="chatroom-subscription"
export default class extends Controller {
  static values = {
    ids: String
  }

  static targets = ["latestMessages",
                "latestMessage",
                "cleartextField",
                "chatField",
                "scrollContent",
                "timestamp"]

  connect() {
    this.timestampTargets.forEach(target => {
      target.innerHTML = moment(target.innerHTML).fromNow()
    })
    this.channel = []
    this.chatrooms = this.idsValue.split(',')
    this.chatrooms.forEach((id, i) => {
      this.channel[i] = createConsumer().subscriptions.create(
        { channel: "ChatroomChannel", id: parseInt(id) },
        {
          received: data => {
            console.log(data)
            this.latestMessagesTargets[i].innerHTML += data
            this.latestMessageTargets[i].innerHTML = data
            this.timestampTargets[i].innerHTML = moment(this.latestMessageTargets[i].querySelector('i').innerHTML).fromNow()
            this.latestMessageTargets[i].innerHTML = this.latestMessageTargets[i].querySelector('p').innerText
            this.chatFieldTargets[i].value = ""
            // this.scrollContentTargets[i].scrollBy(0, Number.MAX_SAFE_INTEGER)
            this.scrollContentTargets.forEach(e => {
              e.scrollTop = e.scrollHeight; // Scroll to the bottom
            });
            this.formatDateTime()
          }
        }
      )
    })
    this.currentChatroom = this.chatrooms[0]
    this.scrollContentTargets.forEach(e => e.scrollBy(0, Number.MAX_SAFE_INTEGER))
    this.clearInactiveChatrooms()
    this.formatDateTime()
  }

  formatDateTime() {
    document.querySelectorAll('.datetime').forEach(elem => {
      elem.innerHTML = moment(elem.dataset.originalDate).fromNow()
    })
  }

  clearInactiveChatrooms() {
    const chatrooms = this.chatrooms.filter(c => c != this.currentChatroom)
    chatrooms.forEach(c => document.querySelectorAll(`.event-${c}`).forEach(e => e.style.display = 'none'))
    document.querySelectorAll(`.event-${this.currentChatroom}`).forEach(e => e.style.display = 'block')
  }

  clearTextField(index) {
    this.cleartextFieldTargets[index].value = "";
  }

  selectChat(event) {
    this.currentChatroom = event.target.closest('li').dataset.chatroomId
    this.clearInactiveChatrooms()
  }

  deleteConversation(event) {
    const confirmation = confirm("Are you sure you want to delete this conversation?");
    if (!confirmation) {
      return;
    }

    const chatroomId = event.currentTarget.dataset.chatroomId; // Assuming you have a dataset attribute on the button
    const url = `/chatrooms/${chatroomId}/delete_conversation?timestamp=${Date.now()}`;

    fetch(url, {
      method: 'DELETE',
      headers: {
        'Content-Type': 'application/json',
        'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content,
      },
    })
    .then(response => {
      if (response.ok) {
        // Assuming you want to remove the messages from the UI after deletion
        this.latestMessagesTargets.forEach((target, i) => {
          if (this.chatrooms[i] == chatroomId) {
            target.innerHTML = ""; // Clear messages in the UI
          }
        });

        console.log('Conversation deleted successfully.');
      } else {
        console.error('Error deleting conversation.');
      }
    })
    .catch(error => {
      console.error('Error:', error);
    });
  }

}
