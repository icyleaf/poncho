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
- [ ] Loader
  - [ ] Load to `ENV`
- [ ] Writer
  - [ ] store to file

## Added

- Add new parameter `overwrite : Bool` to `#parse` method, by default `false` means that it sets value once with same key.
- Add `#parse!` method to parse dotenv and overwrite the value with same key, sames as `#parse(true)`.

## Changed

- Change behavior with `Poncho::Parser.new` it does **NOT** parse automatic, you need call `#parse` method.

## 0.1.1 (2017-07-27)

## Added

- Added `#to_h` methods.

## 0.1.0 (2017-07-24)

:star2:First beta version.:star2:

[Unreleased]: https://github.com/icyleaf/poncho/compare/v0.1.1...HEAD
[0.1.1]: https://github.com/icyleaf/poncho/compare/v0.1.0...v0.1.1
[0.1.0]: https://github.com/icyleaf/poncho/compare/04d17738bcb7c15000ae56fea6c72157a96edfc4...v0.1.0
