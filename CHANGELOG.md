## [Unreleased]

## [1.0.2] - 2025-04-23

### Fixed
- Fixed an accidental dependency on `rails (~> 7.0)` that unnecessarily restricted usage to Rails 7 applications.

### Changed
- Removed the `rails` dependency to allow broader compatibility with non-Rails or older Rails environments.

## [1.0.1] - 2025-04-23

### Changed
- Updated gem dependencies to avoid open-ended version warnings:
    - Changed `faraday` from `>= 2.0` to `~> 2.3`
    - Changed `faraday-typhoeus` from `>= 0` to `~> 1.1`
    - Changed `faraday-follow_redirects` from `>= 0` to `~> 0.3.0`

## [1.0.0] - 2025-04-23

### Changed
- **[BREAKING CHANGE]** Updated the `faraday` dependency to `>= 2.0`, dropping support for older versions.
- Internal adjustments to ensure compatibility with Faraday 2.x.

### Removed
- Support for Faraday versions below 2.0.

## [0.1.1] - 2024-11-23

- Removed hard dependency on Rails 7.

## [0.1.0] - 2024-09-30

- Initial release.
