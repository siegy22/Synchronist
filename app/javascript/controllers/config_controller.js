import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["sender", "receiver"]

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
}
