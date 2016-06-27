exports.config =
  files:
    javascripts:
      joinTo:
        "js/app.js":         (str) -> str.indexOf("app.js") != -1
        "js/deps.js":        (str) -> str.indexOf("vendor") != -1
        "js/live_update.js": (str) -> str.indexOf("app.js") == -1 && str.indexOf("vendor") == -1

    stylesheets:
      joinTo: "css/app.css"
      order:
        after: [ "web/static/css/app.css" ]

    templates:
      joinTo: "js/app.js"

  conventions:
    assets: /^(web\/static\/assets)/

  paths:
    watched: [
      "deps/phoenix/priv/static"
      "web/static"
      "test/static"
    ]

    public: "priv/static"

  plugins:
    babel:
      ignore: [ /web\/static\/vendor/ ]

  # Modules and npm config is set to not use require.js wrapping
  # so that the simple hot code reloading works. This setup isn't meant
  # for building big apps so should work just fine without module wrapping.
  modules:
    wrapper: false
    definition: false

  npm:
    enabled: false

  # The source map file was not available on hot-code reloading so it casued
  # an error. I don't use source maps, so the easiest fix is to disable them.
  sourceMaps: false
