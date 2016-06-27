# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# Configures the endpoint
config :livecoding_workspace, LivecodingWorkspace.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "8EEfZGoG6YSeHoXcDw69ITxPG6XF8ajhegAPC1EsB1FbYwpZzUW4JXaF9JFHZoRA",
  render_errors: [view: LivecodingWorkspace.ErrorView, accepts: ~w(html json)],
  pubsub: [name: LivecodingWorkspace.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
