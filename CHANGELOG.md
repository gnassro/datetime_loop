## [1.3.1] - (2025-04-17)
- Fixed `triggerOnStateChange` in `DateTimeLoopBuilder` to trigger immediate builds on init and parent rebuilds (Flutter issue #64916).
- Updated example app’s Android code for Flutter > 3.27 compatibility.
- Updated `README`.

## [1.3.0] - (2025-03-06)
### Added
- `DateTimeLoopController` for stream-based datetime updates.

### Changed
- Replaced internal `DateTimeLoopProvider` with `DateTimeLoopController`.
- updated examples.

## [1.2.1] - (2024-11-09)
### Added
- Example: `clock_example.dart`.

### Changed
- Updated `README`.
- Code formatting to ensure compliance with `pub.dev` standards.
- Minor update to the example usage.

## 1.2.0 (2024-04-02)

* **New Feature:** Added `milliseconds` to `TimeUnit`.
* update example

## 1.1.1 (2024-04-02)

* add example pubspec.lock to gitignore

## 1.1.0 (2024-03-10)

**Changes:**

* **New Feature:** Added `triggerOnStateChange` parameter to `DateTimeLoopBuilder`.

## 1.0.1

* remove unused code
* add example

## 1.0.0

* initial release
