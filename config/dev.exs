use Mix.Config

# For development, we disable any cache and enable
# debugging and code reloading.
#
# The watchers configuration can be used to run external
# watchers to your application. For example, we use it
# with brunch.io to recompile .js and .css sources.
config :livecoding_workspace, LivecodingWorkspace.Endpoint,
  http: [port: 4000],
  debug_errors: true,
  code_reloader: true,
  check_origin: false,
  watchers: [node: ["node_modules/brunch/bin/brunch", "watch", "--stdin",
                    cd: Path.expand("../", __DIR__)]]

config :livecoding_workspace,
  three_js_url: "http://cdnjs.cloudflare.com/ajax/libs/three.js/r57/three.min.js"

# Watch static and templates for browser reloading.
config :livecoding_workspace, LivecodingWorkspace.Endpoint,
  live_reload: [
    patterns: [
       # js intentionally not included here since we want to hot-reload
       # the js code for a quicker development flow.
      ~r{priv/static/.*(css|png|jpeg|jpg|gif|svg)$},
      ~r{priv/gettext/.*(po)$},
      ~r{web/views/.*(ex)$},
      ~r{web/templates/.*(eex)$}
    ]
  ]

# Do not include metadata nor timestamps in development logs
config :logger, :console, format: "[$level] $message\n"

# Set a higher stacktrace during development. Avoid configuring such
# in production as building large stacktraces may be expensive.
config :phoenix, :stacktrace_depth, 20
