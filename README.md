![poncho-logo](https://github.com/icyleaf/poncho/raw/master/logo-small.png)

# Poncho

[![Language](https://img.shields.io/badge/language-crystal-776791.svg)](https://github.com/crystal-lang/crystal)
[![Tag](https://img.shields.io/github/tag/icyleaf/poncho.svg)](https://github.com/icyleaf/poncho/blob/master/CHANGELOG.md)
[![Build Status](https://img.shields.io/circleci/project/github/icyleaf/poncho/master.svg?style=flat)](https://circleci.com/gh/icyleaf/poncho)

A .env parser/loader improved for performance. Poncho Icon by lastspark from <a href="https://thenounproject.com">Noun Project</a>.

<!-- TOC -->

- [Installation](#installation)
- [Usage](#usage)
- [Parse dotenv](#parse-dotenv)
- [Contributing](#contributing)
- [Contributors](#contributors)

<!-- /TOC -->

## Installation

Add this to your application's `shard.yml`:

```yaml
dependencies:
  poncho:
    github: icyleaf/poncho
```

## Usage

```crystal
require "poncho"
```

## Parse dotenv

```crystal
poncho = Poncho.from_file ".env"
# or
poncho = Poncho.parse "PONCHO_ENV=development"

poncho["PONCHO_ENV"] # => "development"
```

## Contributing

1. Fork it (<https://github.com/icyleaf/poncho/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [icyleaf](https://github.com/icyleaf) icyleaf - creator, maintainer

## You may also like

- [halite](https://github.com/icyleaf/halite) - Crystal HTTP Requests Client with a chainable REST API, built-in sessions and loggers.
- [totem](https://github.com/icyleaf/totem) - Load and parse a configuration file or string in JSON, YAML, dotenv formats.
- [popcorn](https://github.com/icyleaf/popcorn) - Easy and Safe casting from one type to another.
- [fast-crystal](https://github.com/icyleaf/fast-crystal) - 💨 Writing Fast Crystal 😍 -- Collect Common Crystal idioms.
