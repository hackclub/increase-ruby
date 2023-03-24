# Changelog

## [0.3.1] - 2023-03-23

### Enhancements

- Support Faraday >= 1.0.1 (https://github.com/garyhtou/increase-ruby/pull/8)


## [0.3.0] - 2023-03-23

### Enhancements

- Better developer experience for file uploads (9fc40df62a537ed3402a0c0deb5bee908d84b671)

### Documentation

- Pin gem version in install command (2127f5a04be8832ba5c5c42476e2844fb6ca9c24)
- Update README to reflect new file upload DX (9fc40df62a537ed3402a0c0deb5bee908d84b671)


## [0.2.0] - 2023-03-21

### Enhancements

- Made webhook verification `verify` raise an error, but `verify?` return a bool (58d462fc648cafdcfdb7b8d2c0e0ec1f45362984)
- Wrote a generator to generate API resource classes from the OpenAPI spec (8eedc2d4a5daecd97c156546c649f27376eb9762)
- Added all API resources (2a04096dea06a34ba8ff1d5061475ed1a2354ac2)
- Supported getting response from `list` operation (a2141f034a4f29cfee0222a4fac32949581adbc6)

### Fixes

- Use `ArgumentError` when unknown config passed to `Configuration` (cdd0703febd6f9dec0ecd4ac34fe465697edbf08)
- File uploads! Increase::Files.create now works (236cad5011b996b40793abe85698ba47fa1ba3f8)

### Documentation

- Updated error handling example to be more clear (85d8d6ff102a8ef502040322537b79085f89779d)
- Fixed idempotency example (343ae6d4cb1b8216192e2f820836ca87cc3a9a36)
- Added example for passing hash to `with_config` (b82fac134c813d03a31466e83341acc891c1deb6)
- Updated Rails config example to use Rails credentials (2b4fec9c1d52d04e42760a9889ba1cb313b5bd18)
- Added list filtering example (6333f982062b2527f676a6aade4e5abf01a7816b)
- Added table of contents (88e9b6ae05aaa62974514a6c318f35e708e49fb5)
- Added full example for Idempotency keys (6d5ce8bdd3d4baf13c4d0800a159c784bc1bdc78)
- Added manual pagination example using `next_cursor` (57157e2965904c9150676696e8567b5518892945)


## [0.1.3] - 2023-03-20

### Enhancements

- Added `Limits` resource (98654433812b202ecfd31ba35d520981529f2e2b)
- Added `CheckTransfers` resource (a899c9ca6206af78df23ba8b62c8dfc88b7fc22d)
- Added `RoutingNumbers` resource (209e7f279a1ff648142ac6aca6cfe946fc653845)

### Documentation

- Added section about webhook signature verification (650aed416ab820ed55f0ed8936f201274964fc37)
- Added section about Rails configuration (650aed416ab820ed55f0ed8936f201274964fc37)

## [0.1.2] - 2023-03-20

### Enhancements

- Added webhook verification support (ce193fb8888d497817ab5551bf8e9096c5bf7e26)
- Added user agent to requests (ce44249ead32ba4055b13ba576f0b91f20493cfc)
- Update supported Ruby version to >= 2.7.4 (c404f8ddc4762615bac660edabf0385716b4bd74)

### Fixes

- Always apply default configuration options (079f0ca603a80dd2c9523df23244b64e2e0a5772)

### Documentation

- Wrote the README! (aa7c778834cd268ab1318e44fceea0b062a5c5df)


## [0.1.1] - 2023-03-19

### Enhancements
- Added client-wide configuration options (c47e32c93371b43f2e0a3ac49525e46fbe9ef326)
- Load `INCREASE_API_KEY` and `INCREASE_BASE_URL` from environment variables (2e6cbe21a2b37c230dc3f2382613b98ffc3ea4d8, 24cea582c03b64018ed2f0997f99f4bae581a1fa, 4a80e4263c7917bbfa1371c70752476d7f7f0695)
- Added the following API resources:
  - `AccountNumbers` (209b155c0fa3977c2c19602a2239c8b27001935e)
  - `AccountTransfers` (6065a932522bd582aa4f177037a5eca8e5d1647d)
  - `AchTransfers` (caef61c36bfffc780016880959f067b59bfa288e)
  - `Cards` (b58bccc8aab00fd2ee69f2973898e6a13c1b2544)
  - `Events` (dd3312638227be47f04c8bd740c3dd25104959e7)
  - `PendingTransactions` (b6f4b2c02a9108603b4d1feee9a39c1a7f1086ef)
  - `Transaction` (b6f4b2c02a9108603b4d1feee9a39c1a7f1086ef)
