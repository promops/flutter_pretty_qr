## 3.6.0

* Add configurable bounds for QR code shapes.
* Optimized QR code rendering for the simple shape variants.
* Add support custom clippers for embedded images [#38](https://github.com/promops/flutter_pretty_qr/issues/66).

## 3.5.0

* Added new patterns: [dots](https://pub.dev/documentation/pretty_qr_code/latest/pretty_qr_code/PrettyQrDotsSymbol-class.html) and [squares](https://pub.dev/documentation/pretty_qr_code/latest/pretty_qr_code/PrettyQrSquaresSymbol-class.html).
* Added support custom styles per QR components [#51](https://github.com/promops/flutter_pretty_qr/pull/62).
* **DEPRECATED**: `PrettyQrRoundedSymbol` shape is now deprecated in favor of the `PrettyQrSquaresSymbol`.

## 3.4.0

* Added quiet zone support [#44](https://github.com/promops/flutter_pretty_qr/pull/56).
* Updated web renderer detection [#55](https://github.com/promops/flutter_pretty_qr/pull/57).
* Added support compilation to WASM. Thanks to [s-philippov (#52)](https://github.com/promops/flutter_pretty_qr/pull/52).

## 3.3.0

* Added `PrettyQrBrush` gradient filling option [#40](https://github.com/promops/flutter_pretty_qr/pull/28).
* Added `PrettyQrTheme` extension [#37](https://github.com/promops/flutter_pretty_qr/pull/37).
* Added assert when platform does not support export.

## 3.2.1

* Fixed bug when errorBuilder was working incorrectly when data was changed.

## 3.2.0

* Added `errorBuilder` to `PrettyQrView.data` constructor.

## 3.1.0

* Optimize QR code repaints [#10](https://github.com/promops/flutter_pretty_qr/issues/10). Thanks to [nxtSwitch  (#28)](https://github.com/promops/flutter_pretty_qr/pull/28).
* Added the ability to save code to an image with `toImage` and `toImageAsBytes` methods [#14](https://github.com/promops/flutter_pretty_qr/issues/14).

## 3.0.0

> Note: This release has breaking changes.

* Added `PrettyQrDecorationTween`.
* Added more options for embedding images.
  * `PrettyQrDecorationImagePosition.embedded`
  * `PrettyQrDecorationImagePosition.background`
  * `PrettyQrDecorationImagePosition.foreground`
* Added core interfaces and refactor internal organization.
* Updated documentation and example to follow new naming conventions.
* **BREAKING**: Package now requires `qr` package `>=3.0.1`.
  * Upgraded Dart SDK constraints to `>=2.17.0 <4.0.0`.
  * Upgraded Flutter SDK constraints to `>=3.0.0 <4.0.0`.
* **DEPRECATED**: `PrettyQr` widget is now deprecated in favor of the `PrettyQrView` widget.
* Update example app.
* Added some new patterns:
  * Rounded (`PrettyQrRoundedSymbol`)
  * Smooth (`PrettyQrSmoothSymbol`)
* Fixed stripes between qr code modules, [#3](https://github.com/promops/flutter_pretty_qr/issues/3).
* Fixed embedded image loading: [#15](https://github.com/promops/flutter_pretty_qr/issues/15).

## 2.0.3

> Note: This release has breaking changes.

* **BREAKING**: Package now requires `qr` package `>=3.0.0`. Thanks to [joj3000 (#11)](https://github.com/promops/flutter_pretty_qr/pull/11).
  * Upgraded Dart SDK constraints to `>=2.13.0 <3.0.0`.

## 2.0.2

* Added automatic detection of the minimum acceptable version number when the `typeNumber` option is omitted. Thanks to [SBNTT (#4)](https://github.com/promops/flutter_pretty_qr/pull/4).

## 2.0.1

* Added `qr` package to exports.
* Refactor internal organization.

## 2.0.0

> Note: This release has breaking changes.

* **BREAKING**: Package now requires `qr` package `>=2.0.0`.
* **BREAKING**: Мigrate to null-safety:
  * Upgraded Dart SDK constraints to `>=2.12.0 <3.0.0`.

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
