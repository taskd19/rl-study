use Mix.Config

config :logger,
  level: :debug,
  backends: [:console]

config :logger, :console,
  # https://hexdocs.pm/logger/Logger.Formatter.html
  format: "\n$date $time {$metadata}[$level] $levelpad$message\n",
  metadata: [:application, :mfa, :line]
