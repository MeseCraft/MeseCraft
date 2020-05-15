# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [1.0.2] - 2020-01-16

### Fixed

- Fix crash when creating an entity if a player leaves the server quickly.

### Changed

- Restore Minetest 0.4.17 support. The version check works only with `minetest_game` with the `player_api` mod added in Minetest 5.0.

## [1.0.1] - 2020-01-01

### Changed

- Improve performance by localizing the `vector.distance()` function.

## 1.0.0 - 2020-01-01

- Initial versioned release.

[Unreleased]: https://github.com/minetest-mods/gauges/compare/v1.0.1...HEAD
[1.0.1]: https://github.com/minetest-mods/gauges/compare/v1.0.0...v1.0.1
