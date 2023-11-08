import { Controller } from "@hotwired/stimulus"
import { createConsumer } from "@rails/actioncable"

// Connects to data-controller="chatroom-subscription"
export default class extends Controller {
  static values = {
    ids: String
  }

  connect() {
    this.channel = []
    this.idsValue.split(',').forEach((id, i) => {
      this.channel[i] = createConsumer().subscriptions.create(
        { channel: "ChatroomChannel", id: parseInt(id) },
        { received: data => console.log(data) }
      )
    })
  }
}
