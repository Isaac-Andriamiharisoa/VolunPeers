import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="caroussel"
export default class extends Controller {

  static targets = ["next", "previous", "slides", "caroussel"]

  connect() {
    this.offset = 0
    this.first_slide = this.slidesTarget.children[this.offset]
    this.first_slide.classList.toggle("active")
    this.intervalId = setInterval(() => this.next(), 30000);
  }

  showSlide() {
    this.first_slide.classList.toggle("active")
    this.first_slide = this.slidesTarget.children[this.offset]
    this.first_slide.classList.toggle("active")
  }

  next() {
    if (this.offset >= this.slidesTarget.children.length - 1) {
      this.offset = 0
    } else {
      this.offset += 1;
    }
    this.showSlide()
  }

  previous() {
    if (this.offset <= 0) {
      this.offset = this.slidesTarget.children.length - 1
    } else {
      this.offset -= 1;
    }
    this.showSlide()
  }
}
