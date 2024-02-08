import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:pretty_qr_code/src/widgets/pretty_qr_theme.dart';
import 'package:pretty_qr_code/src/painting/shapes/pretty_qr_smooth_symbol.dart';
import 'package:pretty_qr_code/src/painting/decoration/pretty_qr_decoration.dart';
import 'package:pretty_qr_code/src/painting/decoration/pretty_qr_decoration_image.dart';

void main() {
  group('PrettyQrTheme.fallback', () {
    test(
      'correct default decoration value',
      () {
        expect(
          PrettyQrTheme.kDefaultDecoration,
          equals(const PrettyQrDecoration(shape: PrettyQrSmoothSymbol())),
        );
      },
    );

    testWidgets(
      'provides default decoration',
      (tester) async {
        // act
        const prettyQrTheme = PrettyQrTheme.fallback();

        // assert
        expect(
          prettyQrTheme.decoration,
          equals(PrettyQrTheme.kDefaultDecoration),
        );
      },
    );
  });

  group('PrettyQrTheme.of', () {
    testWidgets(
      'returns the default decoration when not set',
      (tester) async {
        // arrange
        const placeholderKey = Key('pretty_qr_placeholder');
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData(
              extensions: const {},
            ),
            home: const Placeholder(key: placeholderKey),
          ),
        );

        // act
        final prettyQrTheme = PrettyQrTheme.of(
          tester.element(find.byKey(placeholderKey)),
        );

        // assert
        expect(
          prettyQrTheme.decoration,
          equals(PrettyQrTheme.kDefaultDecoration),
        );
      },
    );

    testWidgets(
      'can be obtained',
      (tester) async {
        // arrange
        const placeholderKey = Key('pretty_qr_placeholder');
        const testQrDecoration = PrettyQrDecoration(
          shape: PrettyQrSmoothSymbol(color: Colors.blue),
        );

        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData(
              extensions: {
                const PrettyQrTheme(
                  decoration: testQrDecoration,
                ),
              },
            ),
            home: const Placeholder(key: placeholderKey),
          ),
        );

        // act
        final prettyQrTheme = PrettyQrTheme.of(
          tester.element(find.byKey(placeholderKey)),
        );

        // assert
        expect(
          prettyQrTheme.decoration,
          equals(testQrDecoration),
        );
      },
    );
  });

  group('PrettyQrTheme', () {
    testWidgets(
      'can be obtained by material theme api',
      (tester) async {
        // arrange
        const placeholderKey = Key('pretty_qr_placeholder');
        const testQrDecoration = PrettyQrDecoration(
          shape: PrettyQrSmoothSymbol(color: Colors.blue),
        );

        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData(
              extensions: {
                const PrettyQrTheme(
                  decoration: testQrDecoration,
                ),
              },
            ),
            home: const Placeholder(key: placeholderKey),
          ),
        );

        // act
        final theme = Theme.of(
          tester.element(find.byKey(placeholderKey)),
        );
        final prettyQrTheme = theme.extension<PrettyQrTheme>();

        // assert
        expect(prettyQrTheme?.decoration, equals(testQrDecoration));
      },
    );

    test(
      'copyWith returns copy of the object',
      () {
        // arrange
        const prettyQrTheme = PrettyQrTheme(
          decoration: PrettyQrDecoration(
            shape: PrettyQrSmoothSymbol(color: Colors.red),
          ),
        );

        // act
        final updatedPrettyQrTheme = prettyQrTheme.copyWith();

        // assert
        expect(updatedPrettyQrTheme, equals(prettyQrTheme));
        expect(identical(prettyQrTheme, updatedPrettyQrTheme), isFalse);
      },
    );

    testWidgets(
      'copyWith returns updated state with replaced decoration value',
      (tester) async {
        // arrange
        const updatedQrDecoration = PrettyQrDecoration(
          shape: PrettyQrSmoothSymbol(
            color: Colors.yellow,
          ),
        );

        // act
        final prettyQrTheme = const PrettyQrTheme(
          decoration: PrettyQrDecoration(
            shape: PrettyQrSmoothSymbol(color: Colors.blue),
          ),
        ).copyWith(decoration: updatedQrDecoration);

        // assert
        expect(prettyQrTheme.decoration, equals(updatedQrDecoration));
      },
    );

    testWidgets(
      'lerps correctly',
      (tester) async {
        // arrange
        const decoration1 = PrettyQrDecoration(
          shape: PrettyQrSmoothSymbol(color: Colors.green),
        );
        const decoration2 = PrettyQrDecoration(
          shape: PrettyQrSmoothSymbol(color: Colors.yellow),
        );

        // act
        final lerpedThemeData = ThemeData.lerp(
          ThemeData(extensions: const [PrettyQrTheme(decoration: decoration1)]),
          ThemeData(extensions: const [PrettyQrTheme(decoration: decoration2)]),
          0.5,
        );

        // assert
        expect(
          lerpedThemeData.extension<PrettyQrTheme>()?.decoration,
          equals(PrettyQrDecoration.lerp(decoration1, decoration2, 0.5)),
        );
      },
    );

    testWidgets(
      'lerp returns correct theme state',
      (tester) async {
        // arrange
        const decorationA = PrettyQrDecoration(
          shape: PrettyQrSmoothSymbol(color: Colors.green),
        );
        const decorationB = PrettyQrDecoration(
          shape: PrettyQrSmoothSymbol(color: Colors.yellow),
        );

        // act
        final lerpedThemeData = ThemeData.lerp(
          ThemeData(extensions: const [PrettyQrTheme(decoration: decorationA)]),
          ThemeData(extensions: const [PrettyQrTheme(decoration: decorationB)]),
          0.5,
        );

        // assert
        expect(
          lerpedThemeData.extension<PrettyQrTheme>()?.decoration,
          equals(PrettyQrDecoration.lerp(decorationA, decorationB, 0.5)),
        );
      },
    );

    testWidgets(
      'lerp returns correct value when destination is null',
      (tester) async {
        // arrange
        const prettyQrTheme = PrettyQrTheme(
          decoration: PrettyQrDecoration(
            shape: PrettyQrSmoothSymbol(color: Colors.green),
          ),
        );

        // act
        final lerpedThemeData = ThemeData.lerp(
          ThemeData(extensions: const [prettyQrTheme]),
          ThemeData(extensions: const []),
          0.5,
        );

        // assert
        expect(
          identical(lerpedThemeData.extension<PrettyQrTheme>(), prettyQrTheme),
          isTrue,
        );
      },
    );

    testWidgets(
      'lerp returns correct value when destination identical to current theme',
      (tester) async {
        // arrange
        const prettyQrTheme = PrettyQrTheme(
          decoration: PrettyQrDecoration(
            shape: PrettyQrSmoothSymbol(color: Colors.green),
          ),
        );

        // act
        final lerpedThemeData = ThemeData.lerp(
          ThemeData(extensions: const [prettyQrTheme]),
          ThemeData(extensions: const [prettyQrTheme]),
          0.5,
        );

        // assert
        expect(
          identical(lerpedThemeData.extension<PrettyQrTheme>(), prettyQrTheme),
          isTrue,
        );
      },
    );

    testWidgets(
      'implements debugFillProperties',
      (WidgetTester tester) async {
        // arrange
        final builder = DiagnosticPropertiesBuilder();
        const prettyQrTheme = PrettyQrTheme(
          decoration: PrettyQrDecoration(
            shape: PrettyQrSmoothSymbol(color: Colors.blue),
          ),
        );

        // act
        prettyQrTheme.debugFillProperties(builder);

        // assert
        final description = [
          ...builder.properties.map((node) => node.toString()),
        ];

        expect(description.length, equals(1));
        expect(
          description,
          equalsIgnoringHashCodes([
            'decoration: PrettyQrDecoration(shape: Instance of \'PrettyQrSmoothSymbol\')',
          ]),
        );
      },
    );
  });

  group('PrettyQrDecorationThemeExtension', () {
    test(
      'returns theme decoration when current decoration is null',
      () {
        // arrange
        const prettyQrTheme = PrettyQrTheme(
          decoration: PrettyQrDecoration(
            image: PrettyQrDecorationImage(
              image: AssetImage('images/flutter.png'),
            ),
            shape: PrettyQrSmoothSymbol(color: Colors.green),
          ),
        );

        // act
        final mergedDecoration = null.applyDefaults(prettyQrTheme);

        // assert
        expect(mergedDecoration.shape, equals(prettyQrTheme.decoration.shape));
        expect(mergedDecoration.image, equals(prettyQrTheme.decoration.image));
      },
    );

    test(
      'correctly merged current decoration with theme decoration',
      () {
        // arrange
        const decoration = PrettyQrDecoration(
          shape: PrettyQrSmoothSymbol(color: Colors.yellow),
        );
        const prettyQrTheme = PrettyQrTheme(
          decoration: PrettyQrDecoration(
            image: PrettyQrDecorationImage(
              image: AssetImage('images/flutter.png'),
            ),
            shape: PrettyQrSmoothSymbol(color: Colors.green),
          ),
        );

        // act
        final mergedDecoration = decoration.applyDefaults(prettyQrTheme);

        // assert
        expect(mergedDecoration.shape, equals(decoration.shape));
        expect(mergedDecoration.image, equals(prettyQrTheme.decoration.image));
      },
    );
  });
}
