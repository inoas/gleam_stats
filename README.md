# stats

A Gleam project for generating and working with random numbers. Documentation is available on [Github Pages](https://nicklasxyz.github.io/stats/) 

## Quick start

```sh
# Run the eunit tests
rebar3 eunit

# Run the Erlang REPL
rebar3 shell
```

## Installation

This package can be installed by adding `stats` to your `rebar.config` dependencies:

```erlang
{deps, [
     {stats, "", 
        {git, "git://github.com/nicklasxyz/stats.git",
            {branch, "main"}
        }
    },
]}.
```
