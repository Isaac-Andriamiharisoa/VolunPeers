# Pin npm packages by running ./bin/importmap

pin "application", preload: true
pin "@hotwired/turbo-rails", to: "turbo.min.js", preload: true
pin "@hotwired/stimulus", to: "stimulus.min.js", preload: true
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js", preload: true
pin_all_from "app/javascript/controllers", under: "controllers"
pin "bootstrap" # @5.3.3
pin "@popperjs/core", to: "@popperjs--core.js" # @2.11.8
pin "@rails/actioncable", to: "https://cdn.jsdelivr.net/npm/@rails/actioncable@7.1.1/app/assets/javascripts/actioncable.esm.js"
pin "mapbox-gl", to: "https://ga.jspm.io/npm:mapbox-gl@2.15.0/dist/mapbox-gl.js"
pin "process", to: "https://ga.jspm.io/npm:@jspm/core@2.0.1/nodelibs/browser/process-production.js"
pin "moment", to: "https://ga.jspm.io/npm:moment@2.29.4/moment.js"
pin "@rails/ujs", to: "https://ga.jspm.io/npm:@rails/ujs@7.0.3-1/lib/assets/compiled/rails-ujs.js"
