<div align="center">
  <h1>dotfiles client</h1>

[![Deno CI](https://github.com/ucpr/dotfiles/actions/workflows/deno-ci.yaml/badge.svg)](https://github.com/ucpr/dotfiles/actions/workflows/deno-ci.yaml)
[![Configuration Tester](https://github.com/ucpr/dotfiles/actions/workflows/configuration-tester.yaml/badge.svg)](https://github.com/ucpr/dotfiles/actions/workflows/configuration-tester.yaml)

</div>

## Requirements

- Deno

## Commands

### logo

This command only outputs Logo.

```
$ deno run main.ts logo

     _       _    __ _ _
  __| | ___ | |_ / _(_) | ___  ___
 / _  |/ _ \| __| |_| | |/ _ \/ __|
| (_| | (_) | |_|  _| | |  __/\__ \
 \__,_|\___/ \__|_| |_|_|\___||___/

  https://github.com/ucpr/dotfiles
```

### healthcheck

This command is used to check if the settings are normal.

```
$ deno run main.ts healthcheck
```

### setup

This command sets up dotfiles. If they are already set up, they will be skipped.

```
$ deno run main.ts setup
```
