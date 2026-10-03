import "@hotwired/turbo-rails"
import "chartkick"
import "Chart.bundle"

// Bootstrap's bundle is loaded with defer; tooltips need initialising after each Turbo visit
document.addEventListener("turbo:load", () => {
  if (!window.bootstrap) return
  document.querySelectorAll("a[rel='tooltip']").forEach((el) => bootstrap.Tooltip.getOrCreateInstance(el))
})
