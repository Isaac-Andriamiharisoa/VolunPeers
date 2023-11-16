import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="countdown"
export default class extends Controller {

  static targets = ["days", "hours", "minutes", "seconds", "daysLeft", "timeLeft"]
  connect() {
    this.updateCountdown();
    this.intervalId = setInterval(() => this.updateCountdown(), 1000);
  }

  updateCountdown() {
    let event_date = this.daysLeftTarget.value
    let event_time = this.timeLeftTarget.value
    const event_date_time_string = `${event_date}T${event_time}`;
    const event_date_time = new Date(event_date_time_string)
    const now = new Date()

    const timeDifference = event_date_time - now;

    const days = Math.floor(timeDifference / (1000 * 60 * 60 * 24));
    const hours = Math.floor((timeDifference % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60));
    const minutes = Math.floor((timeDifference % (1000 * 60 * 60)) / (1000 * 60));
    const seconds = Math.floor((timeDifference % (1000 * 60)) / 1000);
    this.daysTarget.innerText = days
    this.hoursTarget.innerText = hours
    this.minutesTarget.innerText = minutes
    this.secondsTarget.innerText = seconds
  }
}
