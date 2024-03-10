<p align="center">
  <img src="https://raw.githubusercontent.com/promops/flutter_pretty_qr/master/resources/pretty-qr-code.png"/> 
</p>

## Pretty QR Code

<p align="left">
  <a href="https://pub.dev/packages/pretty_qr_code"><img src="https://img.shields.io/pub/v/pretty_qr_code.svg" alt="Pub"></a>
  <a href="https://pub.dev/packages/pretty_qr_code/score"><img src="https://img.shields.io/pub/likes/pretty_qr_code?logo=dart" alt="Likes on pub.dev"></a>
  <a href="https://github.com/promops/flutter_pretty_qr"><img src="https://img.shields.io/github/stars/promops/flutter_pretty_qr.svg?style=flat&logo=github&colorB=deeppink&label=stars" alt="Star on Github"></a>
  <a href="https://opensource.org/licenses/MIT"><img src="https://img.shields.io/badge/license-MIT-purple.svg" alt="License: MIT"></a>
</p>

A highly customizable Flutter widget that makes it easy to render QR codes. Built on top of the [qr](https://pub.dev/packages/qr) package.

## Features

* [**Live Preview**](https://promops.github.io/flutter_pretty_qr/)
* **Shapes** - The widget provides functionality for rendering various built-in shapes, namely [smooth](https://pub.dev/documentation/pretty_qr_code/latest/pretty_qr_code/PrettyQrSmoothSymbol-class.html) and [rounded](https://pub.dev/documentation/pretty_qr_code/latest/pretty_qr_code/PrettyQrRoundedSymbol-class.html), or you can even create your patterns using the package API.
* **Themes** - Allows you easily switch between themes using the [material theme extension](https://pub.dev/documentation/pretty_qr_code/latest/pretty_qr_code/PrettyQrTheme-class.html).
* **Branding** - Configure the display of the embedded image and adjust its style to best fit your needs.
* **Exporting** - Save the QR сode as an image for sharing, embedding, or anything else.
* **Customization** - Customize the appearance by setting the shape color or filling with a [gradient](https://pub.dev/documentation/pretty_qr_code/latest/pretty_qr_code/PrettyQrBrush-class.html).

If you want to say thank you, star us on GitHub or like us on pub.dev.

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

  qrImage = QrImage(qrCode);
}

@override
Widget build(BuildContext context) {
  return PrettyQrView(
    qrImage: qrImage,
    decoration: const PrettyQrDecoration(),
  );
}
```

**Note:** Do _not_ create `QrImage` inside the `build` method; otherwise, you may have an undesired jank in the UI thread.

## Save the symbol as an image

You can save the QR code as an image using the [toImage](https://pub.dev/documentation/pretty_qr_code/latest/pretty_qr_code/PrettyQrImageExtension/toImage.html) or [toImageAsBytes](https://pub.dev/documentation/pretty_qr_code/latest/pretty_qr_code/PrettyQrImageExtension/toImageAsBytes.html) extension methods that apply to `QrImage`. Optionally, the `configuration` parameter may be used to set additional saving options, such as pixel ratio or text direction.

```dart
final qrCode = QrCode.fromData(
  data: 'lorem ipsum dolor sit amet',
  errorCorrectLevel: QrErrorCorrectLevel.H,
);

final qrImage = QrImage(qrCode);
final qrImageBytes = await qrImage.toImageAsBytes(
  size: 512,
  format: ImageByteFormat.png,
  decoration: const PrettyQrDecoration(),
);
```

See the `example` folder for more code samples of the various possibilities.

## Contributing

Contributions are welcomed!

Here is a curated list of how you can help:

* Fix typos/grammar mistakes
* Report parts of the documentation that are unclear
* Report bugs and scenarios that are difficult to implement

## Planned for future release(s):

* Quiet Zone
* ~~Gradient filling~~
* Add more styles
* ~~Export as image~~
* ~~Error handling API~~
* Gaps between modules
* ~~Background color for QR code~~
* Timing Patterns and Alignment Patterns
* Automatic image scale limitation (embedded mode)
