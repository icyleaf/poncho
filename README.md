![poncho-logo](https://github.com/icyleaf/poncho/raw/master/logo-small.png)

# Poncho

[![Language](https://img.shields.io/badge/language-crystal-776791.svg)](https://github.com/crystal-lang/crystal)
[![Tag](https://img.shields.io/github/tag/icyleaf/poncho.svg)](https://github.com/icyleaf/poncho/blob/master/CHANGELOG.md)
[![Build Status](https://img.shields.io/circleci/project/github/icyleaf/poncho/master.svg?style=flat)](https://circleci.com/gh/icyleaf/poncho)

A .env parser/loader improved for performance. Poncho Icon by lastspark from [Noun Project](https://thenounproject.com).

<!-- TOC -->

- [Installation](#installation)
- [Usage](#usage)
  - [Parse](#parse)
    - [Rules](#rules)
    - [Examples](#examples)
- [Donate](#donate)
- [How to Contribute](#how-to-contribute)
- [You may also like](#you-may-also-like)
- [License](#license)

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

### Parse

Poncho parses the contents of your file containing environment variables is available to use.
It accepts a String or IO and will return an `Hash` with the parsed keys and values.

#### Rules

Poncho parser currently supports the following rules:

- Skipped the empty line and comment(`#`).
- Ignore the comment which after (`#`).
- `NAME=foo` becomes `{"NAME" => "foo"}`.
- Empty values become empty strings.
- Whirespace is removed from right ends of the value.
- Single and Double quoted values are escaped.
- New lines are expanded if in double quotes.
- Inner quotes are maintained (such like json).
- Overwrite optional (default is non-overwrite).
- Only accpets string type value.

#### Examples

```crystal
poncho = Poncho.from_file ".env"
# or
poncho = Poncho.parse("ENV=development\nDB_NAME=poncho\nENV=production")
poncho["ENV"] # => "development"

# Overwrite the key
poncho = Poncho.parse!("ENV=development\nDB_NAME=poncho\nENV=production", overwrite: true)
poncho["ENV"] # => "production"
```

## Donate

Poncho is a open source, collaboratively funded project. If you run a business and are using Poncho in a revenue-generating product,
it would make business sense to sponsor Poncho development. Individual users are also welcome to make a one time donation
if Totem has helped you in your work or personal projects.

You can donate via [Paypal](https://www.paypal.me/icyleaf/5).

## How to Contribute

Your contributions are always welcome! Please submit a pull request or create an issue to add a new question, bug or feature to the list.

All [Contributors](https://github.com/icyleaf/poncho/graphs/contributors) are on the wall.

## You may also like

- [halite](https://github.com/icyleaf/halite) - Crystal HTTP Requests Client with a chainable REST API, built-in sessions and loggers.
- [totem](https://github.com/icyleaf/totem) - Load and parse a configuration file or string in JSON, YAML, dotenv formats.
- [markd](https://github.com/icyleaf/markd) - Yet another markdown parser built for speed, Compliant to CommonMark specification.
- [popcorn](https://github.com/icyleaf/popcorn) - Easy and Safe casting from one type to another.
- [fast-crystal](https://github.com/icyleaf/fast-crystal) - 💨 Writing Fast Crystal 😍 -- Collect Common Crystal idioms.

## License

[MIT License](https://github.com/icyleaf/poncho/blob/master/LICENSE) © icyleaf