use Mix.Config

config :logger,
  level: :info,
  backends: [:console]

config :logger, :console,
  # https://hexdocs.pm/logger/Logger.Formatter.html
  format: "$date $time {$metadata}[$level] $levelpad$message\n",
  metadata: [:application, :mfa, :line]
