use Mix.Config

config :logger,
  level: :debug,
  backends: [:console]

config :logger, :console,
  format: "\n$time {$metadata}[$level] $levelpad$message\n",
  metadata: [:application, :mfa, :line]
