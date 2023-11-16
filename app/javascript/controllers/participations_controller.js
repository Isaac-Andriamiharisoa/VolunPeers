// import { Controller } from "@hotwired/stimulus";

// export default class extends Controller {
//   static targets = ['button'];
//   toggle() {
//     const status = this.buttonTarget.dataset.status;
//     if (status === 'participating') {
//       console.log('Unparticipating...');
//       // Handle logic for unparticipating, e.g., make an AJAX request to remove participation
//       // Change the button's text to "Participate"
//       this.buttonTarget.innerText = 'Participate';
//       // Update the data-status attribute
//       this.buttonTarget.dataset.status = 'participate';
//     } else {
//       console.log('Participating...');
//       // Handle logic for participating, e.g., make an AJAX request to record participation
//       // Change the button's text to "Participating"
//       this.buttonTarget.innerText = 'Participating';
//       // Update the data-status attribute
//       this.buttonTarget.dataset.status = 'participating';
//     }
//   }
// }
