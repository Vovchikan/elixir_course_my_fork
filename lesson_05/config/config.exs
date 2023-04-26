import Config

# Configures Elixir's Logger
config :logger, :console,
  format: "$time - [$level]: $message $metadata\n",
  metadata: :all
