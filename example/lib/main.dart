import 'package:flutter/material.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';

void main() {
  runApp(const PrettyQrExampleApp());
}

class PrettyQrExampleApp extends StatelessWidget {
  const PrettyQrExampleApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.black,
        ),
      ),
      home: const PrettyQrHomePage(),
    );
  }
}

class PrettyQrHomePage extends StatefulWidget {
  const PrettyQrHomePage({
    super.key,
  });

  @override
  State<PrettyQrHomePage> createState() => _PrettyQrHomePageState();
}

class _PrettyQrHomePageState extends State<PrettyQrHomePage> {
  @protected
  late QrCode qrCode;

  @protected
  late QrImage qrImage;

  @protected
  late PrettyQrDecoration previosDecoration;

  @protected
  late PrettyQrDecoration currentDecoration;

  @visibleForTesting
  static const kDefaultPrettyQrDecorationImage = PrettyQrDecorationImage(
    image: AssetImage('images/flutter.png'),
    position: PrettyQrDecorationImagePosition.embedded,
  );

  @protected
  Color get shapeColor {
    var shape = currentDecoration.shape;
    if (shape is PrettyQrSmoothModules) return shape.color;
    if (shape is PrettyQrRoundedRectangleModules) return shape.color;
    return Colors.black;
  }

  @protected
  bool get isRoundedBorders {
    var shape = currentDecoration.shape;
    if (shape is PrettyQrSmoothModules) {
      return shape.roundFactor > 0;
    } else if (shape is PrettyQrRoundedRectangleModules) {
      return shape.borderRadius != BorderRadius.zero;
    }
    return false;
  }

  @override
  void initState() {
    super.initState();

    qrCode = QrCode.fromData(
      data: 'https://pub.dev/packages/pretty_qr_code',
      errorCorrectLevel: QrErrorCorrectLevel.H,
    );

    qrImage = QrImage(qrCode);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final decoration = PrettyQrDecoration(
      shape: PrettyQrSmoothModules(
        color: Theme.of(context).colorScheme.secondary,
      ),
      image: kDefaultPrettyQrDecorationImage,
    );

    previosDecoration = decoration;
    currentDecoration = decoration;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Pretty QR Code'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: TweenAnimationBuilder<PrettyQrDecoration>(
                tween: PrettyQrDecorationTween(
                  begin: previosDecoration,
                  end: currentDecoration,
                ),
                curve: Curves.ease,
                duration: const Duration(
                  milliseconds: 240,
                ),
                builder: (context, decoration, child) {
                  return PrettyQrView(
                    qrImage: qrImage,
                    decoration: decoration,
                  );
                },
              ),
            ),
            PopupMenuButton(
              onSelected: changeShape,
              constraints: const BoxConstraints(
                minWidth: double.infinity,
              ),
              initialValue: currentDecoration.shape.runtimeType,
              itemBuilder: (context) {
                return [
                  const PopupMenuItem(
                    value: PrettyQrSmoothModules,
                    child: Text('Smooth'),
                  ),
                  const PopupMenuItem(
                    value: PrettyQrRoundedRectangleModules,
                    child: Text('Rounded rectangle'),
                  ),
                ];
              },
              child: ListTile(
                leading: const Icon(Icons.format_paint_outlined),
                title: const Text('Style'),
                trailing: Text(
                  currentDecoration.shape is PrettyQrSmoothModules
                      ? 'Smooth'
                      : 'Rounded rectangle',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ),
            ),
            SwitchListTile.adaptive(
              value: shapeColor != Colors.black,
              onChanged: (value) => toggleColor(),
              secondary: const Icon(Icons.color_lens_outlined),
              title: const Text('Colored'),
            ),
            SwitchListTile.adaptive(
              value: isRoundedBorders,
              onChanged: (value) => toggleRoundedCorners(),
              secondary: const Icon(Icons.rounded_corner),
              title: const Text('Rounded corners'),
            ),
            const Divider(),
            SwitchListTile.adaptive(
              value: currentDecoration.image != null,
              onChanged: (value) => toggleImage(),
              secondary: Icon(
                currentDecoration.image != null
                    ? Icons.image_outlined
                    : Icons.hide_image_outlined,
              ),
              title: const Text('Image'),
            ),
            if (currentDecoration.image != null)
              ListTile(
                enabled: currentDecoration.image != null,
                leading: const Icon(Icons.layers_outlined),
                title: const Text('Image position'),
                trailing: PopupMenuButton(
                  onSelected: changeImagePosition,
                  initialValue: currentDecoration.image!.position,
                  itemBuilder: (context) {
                    return [
                      const PopupMenuItem(
                        value: PrettyQrDecorationImagePosition.embedded,
                        child: Text('Embedded'),
                      ),
                      const PopupMenuItem(
                        value: PrettyQrDecorationImagePosition.foreground,
                        child: Text('Foreground'),
                      ),
                      const PopupMenuItem(
                        value: PrettyQrDecorationImagePosition.background,
                        child: Text('Background'),
                      ),
                    ];
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  @protected
  void changeShape(
    final Type value,
  ) {
    var shape = currentDecoration.shape;
    if (shape.runtimeType == value) return;

    if (shape is PrettyQrSmoothModules) {
      shape = PrettyQrRoundedRectangleModules(color: shapeColor);
    } else if (shape is PrettyQrRoundedRectangleModules) {
      shape = PrettyQrSmoothModules(color: shapeColor);
    }

    setState(() {
      previosDecoration = currentDecoration;
      currentDecoration = currentDecoration.copyWith(shape: shape);
    });
  }

  @protected
  void toggleColor() {
    var shape = currentDecoration.shape;
    var color = shapeColor != Colors.black
        ? Colors.black
        : Theme.of(context).colorScheme.secondary;

    if (shape is PrettyQrSmoothModules) {
      shape = PrettyQrSmoothModules(
        color: color,
        roundFactor: shape.roundFactor,
      );
    } else if (shape is PrettyQrRoundedRectangleModules) {
      shape = PrettyQrRoundedRectangleModules(
        color: color,
        borderRadius: shape.borderRadius,
      );
    }

    setState(() {
      previosDecoration = currentDecoration;
      currentDecoration = currentDecoration.copyWith(shape: shape);
    });
  }

  @protected
  void toggleRoundedCorners() {
    var shape = currentDecoration.shape;

    if (shape is PrettyQrSmoothModules) {
      shape = PrettyQrSmoothModules(
        color: shape.color,
        roundFactor: isRoundedBorders ? 0 : 1,
      );
    } else if (shape is PrettyQrRoundedRectangleModules) {
      shape = PrettyQrRoundedRectangleModules(
        color: shape.color,
        borderRadius: isRoundedBorders
            ? BorderRadius.zero
            : const BorderRadius.all(Radius.circular(10)),
      );
    }

    setState(() {
      previosDecoration = currentDecoration;
      currentDecoration = currentDecoration.copyWith(shape: shape);
    });
  }

  @protected
  void toggleImage() {
    var image = currentDecoration.image;
    image = image != null ? null : kDefaultPrettyQrDecorationImage;

    setState(() {
      previosDecoration = currentDecoration;
      currentDecoration = PrettyQrDecoration(
        image: image,
        shape: currentDecoration.shape,
      );
    });
  }

  @protected
  void changeImagePosition(
    final PrettyQrDecorationImagePosition value,
  ) {
    final image = currentDecoration.image?.copyWith(position: value);
    setState(() {
      previosDecoration = currentDecoration;
      currentDecoration = currentDecoration.copyWith(image: image);
    });
  }
}
