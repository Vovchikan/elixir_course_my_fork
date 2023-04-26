import Config

config :logger,
  handle_otp_reports: false,
  handle_sasl_reports: false,
  level: :warning,
  backends: [:console]

config :logger, :console,
  format: "$time - [$level]: $message $metadata\n",
  metadata: [:mfa, :line, :file]
