import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["sender", "receiver", "relay"]

  setSender() {
    this.toggleMode('sender')
  }

  setReceiver() {
    this.toggleMode('receiver')
  }

  toggleMode(mode) {
    if (mode === 'sender') {
      this.senderTarget.classList.remove("d-none")
      this.receiverTarget.classList.add("d-none")
    } else {
      this.receiverTarget.classList.remove("d-none")
      this.senderTarget.classList.add("d-none")
    }
  }

  toggleRelay(e) {
    if (e.target.checked) {
      this.relayTarget.classList.remove("d-none")
    } else {
      this.relayTarget.classList.add("d-none")
    }
  }
}
