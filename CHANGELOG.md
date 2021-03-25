# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

## [Unreleased]

## TODO

- [ ] Parser
  - [x] core engine
  - [ ] support parse to array
  - [ ] support parse to hash
  - [ ] support parse to json
  - [ ] support parse to yaml
- [x] Loader
  - [x] Load to `ENV`
- [ ] Writer
  - [ ] store to file

## [0.4.0] (2021-03-25)

### Fixed

- Compatibility with Crystal 0.31

## [0.3.0] (2018-08-22)

## Added

- Add variables in value support:sparkles:! [#6](https://github.com/icyleaf/poncho/pull/6)

## [0.2.0] (2018-08-20)

### Added

#### Parser

- Add new parameter `overwrite : Bool` to `#parse` method, by default `false` means that it sets value once with same key.
- Add `#parse!` method to parse dotenv and overwrite the value with same key, sames as `#parse(true)`.

#### Loader

Supportd now!

- Support single file with enviroment name and following searching file by orders.
- Support single path and following searching file by orders.
- Support multiple files (ignore searching orders and environment name).
- Support overwrite existing environment variables

See [#3](https://github.com/icyleaf/poncho/pull/3).

### Changed

- Change behavior with `Poncho::Parser.new` it does **NOT** parse automatic, you need call `#parse` method.

### Fixed

- Fix snakecase each part split by "_" do not format full key. `ABC_name` => `A_B_C_NAME` => "ABC_NAME"

## [0.1.1] (2018-07-27)

### Added

- Added `#to_h` methods.

## [0.1.0] (2018-07-24)

:star2:First beta version.:star2:

[Unreleased]: https://github.com/icyleaf/poncho/compare/v0.4.0...HEAD
[0.4.0]: https://github.com/icyleaf/poncho/compare/v0.3.0...v0.4.0
[0.3.0]: https://github.com/icyleaf/poncho/compare/v0.2.0...v0.3.0
[0.2.0]: https://github.com/icyleaf/poncho/compare/v0.1.1...v0.2.0
[0.1.1]: https://github.com/icyleaf/poncho/compare/v0.1.0...v0.1.1
[0.1.0]: https://github.com/icyleaf/poncho/compare/04d17738bcb7c15000ae56fea6c72157a96edfc4...v0.1.0
