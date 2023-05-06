import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["items"]
  // open() {
  //   this.itemsTarget.classList.remove('translate-x-full')
  // }
  // close() {
  //   this.itemsTarget.classList.add('translate-x-full')

  // }
  toggle() {
    this.itemsTarget.classList.toggle('translate-x-full')

  }
}
