import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="floating-card"
export default class extends Controller {
  static targets = ["card1", "card2", "card3"]

  connect() {
    console.log("connected");
    this.animate()
  }

  sleep(ms) {
    return new Promise(resolve => setTimeout(resolve, ms));
  }

  async animate() {
    this.card1Target.style.transform = 'translateY(-5px)';
    await this.sleep(150);
    this.card2Target.style.transform = 'translateY(-5px)';
    await this.sleep(150);
    this.card3Target.style.transform = 'translateY(-5px)';
    await this.sleep(200);
    this.card1Target.style.transform = 'translateY(5px)';
    await this.sleep(150);
    this.card2Target.style.transform = 'translateY(5px)';
    await this.sleep(150);
    this.card3Target.style.transform = 'translateY(5px)';
    await this.sleep(200);
    this.card1Target.style.transform = 'translateY(0px)';
    await this.sleep(150);
    this.card2Target.style.transform = 'translateY(0px)';
    await this.sleep(150);
    this.card3Target.style.transform = 'translateY(0px)';
  }
}
