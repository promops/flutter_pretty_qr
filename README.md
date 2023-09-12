<p align="center">
  <img src="https://raw.githubusercontent.com/promops/flutter_pretty_qr/master/resources/qr-code.png" width="33%" /> 
</p>

## Pretty QR Code

<p align="left">
  <a href="https://pub.dev/packages/pretty_qr_code"><img src="https://img.shields.io/pub/v/pretty_qr_code.svg" alt="Pub"></a>
  <a href="https://pub.dev/packages/pretty_qr_code/score"><img src="https://img.shields.io/pub/likes/pretty_qr_code?logo=dart" alt="Likes on pub.dev"></a>
  <a href="https://github.com/promops/flutter_pretty_qr"><img src="https://img.shields.io/github/stars/promops/flutter_pretty_qr.svg?style=flat&logo=github&colorB=deeppink&label=stars" alt="Star on Github"></a>
  <a href="https://opensource.org/licenses/MIT"><img src="https://img.shields.io/badge/license-MIT-purple.svg" alt="License: MIT"></a>
</p>

A highly customizable Flutter widget that make it easy to rendering QR code.

## Features

* [Live Preview](https://promops.github.io/flutter_pretty_qr/)
* Built on [qr](https://pub.dev/packages/qr) package.
* Supports embedding images.
* Support tween animation
* Support some options for images

If you want to say thank you, star us on GitHub or like us on pub.dev

## Usage

First, follow the [package installation instructions](https://pub.dev/packages/pretty_qr_code/install) and add a `PrettyQrView` widget to your app:

```dart
PrettyQrView.data(
  data: 'lorem ipsum dolor sit amet',
  decoration: const PrettyQrDecoration(
    image: PrettyQrDecorationImage(
      image: AssetImage('images/flutter.png'),
    ),
  ),
)
```

If you want to pass non-string data or want to specify a QR version, consider using the default `PrettyQrView` constructor:

```dart
@protected
late QrImage qrImage;

@override
void initState() {
  super.initState();

  final qrCode = QrCode(
    8,
    QrErrorCorrectLevel.H,
  )..addData('lorem ipsum dolor sit amet');

  qrImage = QrImage(qrCode)
}

@override
Widget build(BuildContext context) {
  return PrettyQrView(
    qrImage: qrImage,
    decoration: const PrettyQrDecoration(),
  );
}
```

**Note:** Do _not_ create `QrImage` inside `build` method, or you may otherwise have undesired jank in UI thread.

See the `example` folder for more code samples of the various possibilities.

## Contributing

Contributions are welcomed!

Here is a curated list of how you can help:

* Fix typos/grammar mistakes
* Report parts of the documentation that are unclear
* Report bugs and scenarios that are difficult to implement

## TODO: 

* Quiet Zone
* Gradient filling 
* Export as image
* Error handling API
* Gaps between modules
* Background color for QR code
* Timing Patterns and Alignment Patterns
* Automatic image scale limitation (embedded mode)
