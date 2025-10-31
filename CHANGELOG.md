## [1.6.0] - (2025-10-31)
- Added `getNow` parameter to `DateTimeLoopBuilder` and `DateTimeLoopController` for testing and mocking system time.
- **Introduced unit testing** to the package:
  - `test/date_time_loop_controller_test.dart`: Tests controller stream emissions for all `TimeUnit` values (milliseconds, seconds, minutes, hours, days) with both `triggerOnStart` true and false.
  - `test/date_time_loop_builder_test.dart`: Tests widget rebuild behavior with different `TimeUnit` and `triggerOnStateChange` configurations.

- Removed internal caching logic (`_lastPushedWidget` and `_lastPushedDateTime`) in `DateTimeLoopBuilder` that was preventing builder from being called when stream emitted the same datetime value.
- Fixed `triggerOnStateChange` behavior to properly trigger rebuilds on every stream emission.
- Update `example/main.dart` file.

## [1.5.0] - (2025-10-24)
- Added `pause()` and `resume()` methods to `DateTimeLoopController` for pausing and resuming datetime updates, 
  useful for resource management (e.g., when the app is backgrounded).
- Added optional `controller` parameter to `DateTimeLoopBuilder` to allow external controller management, enabling advanced features like pause/resume.
- Added example demonstrating pause/resume functionality in `example/lib/pause_resume_example.dart`.
- Updated `README.md`.

## [1.4.0] - (2025-10-24)
- Refactored `DateTimeLoopController` to use `Timer` for periodic updates instead of a `while` loop with `Future.delayed`, improving reliability and resource management.
- Moved initial `DateTime` emission (when `triggerOnStart` is `true`) to `Future.microtask` to allow listeners to subscribe first.
- Added `dispose` method in `DateTimeLoopBuilder` to properly cancel the timer and close the stream controller, preventing potential memory leaks.

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
