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
    - [Overrides](#overrides)
    - [Examples](#examples)
  - [Load](#load)
    - [Orders](#orders)
    - [Overrides](#overrides-1)
    - [Examples](#examples-1)
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

Add your application configuration to your `.env` file in the root of your project:

```bash
MYSQL_HOST=localhost
MYSQL_PORT=3306
MYSQL_DATABASE=poncho
DMYSQL_USER=poncho
MYSQL_PASSWORD=74e10b72-33b1-434b-a476-cfee0faa7d75
```

Now you can parse or load it.

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

#### Overrides

By default, Poncho won't overwrite existing environment variables as dotenv assumes the deployment environment
has more knowledge about configuration than the application does.
To overwrite existing environment variables you can use `Poncho.parse!(string_or_io)` /
`Poncho.from_file(file, overwrite: true)` and `Poncho.parse(string_or_io, overwrite: true)`.

#### Examples

```crystal
require "poncho"
# Or only import parser
require "poncho/parser"

poncho = Poncho.from_file ".env"
# or
poncho = Poncho.parse("ENV=development\nENV=production")
poncho["ENV"] # => "development"

# Overwrite value with exists key
poncho = Poncho.parse!("ENV=development\nENV=production")
poncho["ENV"] # => "production"
```

### Load

Poncho loads the environment file is easy to use. It accepts both single file and multiple files.

#### Orders

Poncho loads **single file** supports the following order with environment name (default is `development`):

- `.env` - The Original®
- `.env.development` - Environment-specific settings.
- `.env.local` - Local overrides. This file is loaded for all environments except `test`.
- `.env.development.local` - Local overrides of environment-specific settings.

> **NO** effect with multiple fiels.

#### Overrides

By default, Poncho won't overwrite existing environment variables as dotenv assumes the deployment environment
has more knowledge about configuration than the application does.
To overwrite existing environment variables you can use `Poncho.load!(*files)` or `Poncho.load(*files, overwrite: true)`.

#### Examples

```crystal
# Load singe file
# Searching order: .env.development, .env.local, .env.development.local
Poncho.load ".env"

# Load production file
# Searching order: .env, .env.production, .env.local, .env.production.local
Poncho.load ".env", env: "production"

# Load multiple files, ignore enviroment name.
Poncho.load ".env", ".env.local", env: "test"
# Searching order: .env, .env.local
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