# config/importmap.rb

# Linhas padrão do Rails
pin "application"
pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "@hotwired/stimulus", to: "stimulus.min.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"
pin_all_from "app/javascript/controllers", under: "controllers"

# Sua adição (correta!), que registra o arquivo da sidebar
pin "sidebar", to: "sidebar.js"
