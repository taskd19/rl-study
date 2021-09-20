# RlStudy

**TODO: Add description**

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `rl_study` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:rl_study, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/rl_study](https://hexdocs.pm/rl_study).

## How to build

```shell
xcode-select --install
mix deps.get
# MaxOS 11.3
C_INCLUDE_PATH=/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/System/Library/Frameworks/Accelerate.framework/Frameworks/vecLib.framework/Headers mix compile
```

## How to run tests

```shell
mix test
```


## References
- https://github.com/versilov/matrex
