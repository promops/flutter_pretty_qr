import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:pretty_qr_code/src/painting/shapes/pretty_qr_smooth_symbol.dart';
import 'package:pretty_qr_code/src/painting/decoration/pretty_qr_decoration.dart';

import 'package:pretty_qr_code/src/widgets/pretty_qr_theme.dart';

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

    test(
      'copyWith returns updated state with replaced decoration value',
      () {
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

    test(
      'lerps correctly',
      () {
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

    test(
      'lerp returns correct theme state',
      () {
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

    test(
      'lerp returns correct value when destination is null',
      () {
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

    test(
      'lerp returns correct value when destination identical to current theme',
      () {
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

    test(
      'implements debugFillProperties',
      () {
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
          equals([
            'decoration: PrettyQrDecoration(shape: Instance of \'PrettyQrSmoothSymbol\')',
          ]),
        );
      },
    );
  });
}
