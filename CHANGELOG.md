## 3.1.0 

* Added the ability to save code to an image with (`toImage`) & (`toImageAsBytes`) methods.


## 3.0.0

> Note: This release has breaking changes.

* Added `PrettyQrDecorationTween`.
* Added more options for embedding images.
  - `PrettyQrDecorationImagePosition.embedded`
  - `PrettyQrDecorationImagePosition.background`
  - `PrettyQrDecorationImagePosition.foreground`
* Added core interfaces and refactor internal organization.
* Updated documentation and example to follow new naming conventions.
* **BREAKING**: Package now requires `qr` package `>=3.0.1`.
  - Upgraded Dart SDK constraints to `>=2.17.0 <4.0.0`.
  - Upgraded Flutter SDK constraints to `>=3.0.0 <4.0.0`.
* **DEPRECATED**: `PrettyQr` widget is now deprecated in favor of the `PrettyQrView` widget.
* Update example app.
* Added some new patterns:
  - Rounded (`PrettyQrRoundedSymbol`)
  - Smooth (`PrettyQrSmoothSymbol`)
* Fixed stripes between qr code modules, [#3](https://github.com/promops/flutter_pretty_qr/issues/3).
* Fixed embedded image loading: [#15](https://github.com/promops/flutter_pretty_qr/issues/15).


## 2.0.3

> Note: This release has breaking changes.

* **BREAKING**: Package now requires `qr` package `>=3.0.0`. Thanks to [joj3000 (#11)](https://github.com/promops/flutter_pretty_qr/pull/11).
  - Upgraded Dart SDK constraints to `>=2.13.0 <3.0.0`.

## 2.0.2

* Added automatic detection of the minimum acceptable version number when the `typeNumber` option is omitted. Thanks to [SBNTT (#4)](https://github.com/promops/flutter_pretty_qr/pull/4).

## 2.0.1

* Added `qr` package to exports.
* Refactor internal organization.

## 2.0.0

> Note: This release has breaking changes.

* **BREAKING**: Package now requires `qr` package `>=2.0.0`.
* **BREAKING**: Мigrate to null-safety:
  - Upgraded Dart SDK constraints to `>=2.12.0 <3.0.0`.

## 1.0.2

* Fixed QR code rebuild when no data changes. Thanks to [daniel-lucas-silva (#5)](https://github.com/promops/flutter_pretty_qr/pull/5).

## 1.0.1

* Removed unnecessary `print` from `PrettyQrCodePainter.paint`.

## 1.0.0

* Fixed QR code displaying without image.

## 0.0.8

* Added example project.

## 0.0.7

* Added support for embedded images.
* Updated screenshots and usage example.

## 0.0.6

* Fixed inner corners color.

## 0.0.5

* Fixed transparent background.

## 0.0.4

* Updated screenshots.
* Added rounding to the inner corners.
* Added a `PrettyQr.typeNumber` property.

## 0.0.3 

* Updated package description.

## 0.0.2 

* Added screenshots and usage example.

## 0.0.1

* Initial version of the library.
