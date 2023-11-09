import { Controller } from "@hotwired/stimulus"
import mapboxgl from 'mapbox-gl'

// Connects to data-controller="map"
export default class extends Controller {
  static values = {
    apiKey: String,
    markers: Array
  }

  static targets= ["content"]

  connect() {
    mapboxgl.accessToken = this.apiKeyValue
    const contentElement = this.contentTarget;

    console.log("connecting to mapbox...")
    console.log(contentElement);

    this.map = new mapboxgl.Map({
      container: contentElement,
      style: "mapbox://styles/mapbox/streets-v10",
      scrollZoom: false
    })

    this.#addMarkersToMap()
    this.#fitMapToMarkers()
  }

  #addMarkersToMap() {
    this.markersValue.forEach((marker) => {
      new mapboxgl.Marker()
        .setLngLat([ marker.lng, marker.lat ])
        .addTo(this.map)
    })
  }

  #fitMapToMarkers() {
    const bounds = new mapboxgl.LngLatBounds()
    this.markersValue.forEach(marker => bounds.extend([ marker.lng, marker.lat ]))
    this.map.fitBounds(bounds, { padding: 70, maxZoom: 15, duration: 0 })
  }
}
