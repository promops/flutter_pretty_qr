// ignore_for_file: deprecated_member_use, migrate to new Color API after Flutter version update.

import 'dart:math';

import 'package:meta/meta.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:pretty_qr_code/src/painting/pretty_qr_brush.dart';

class _NotAPrettyQrSolidBrush extends PrettyQrSolidBrush {
  @literal
  const _NotAPrettyQrSolidBrush(super.value);
}

class _NotAPrettyQrGradientBrush extends PrettyQrGradientBrush {
  @literal
  const _NotAPrettyQrGradientBrush({required super.gradient});
}

class _TestBrushPainter extends CustomPainter {
  @protected
  final PrettyQrBrush brush;

  @protected
  final TextDirection? textDirection;

  @literal
  const _TestBrushPainter({
    required this.brush,
    this.textDirection,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    canvas.drawRect(rect, brush.toPaint(rect, textDirection: textDirection));
  }

  @override
  bool shouldRepaint(_TestBrushPainter oldPainter) => true;
}

void main() {
  // The random color to tests.
  final testColor = Color(Random().nextDouble() * 0xFFFFFF ~/ 1).withOpacity(1);

  group('PrettyQrBrush.transparent', () {
    test(
      'returns correct transparent brush',
      () {
        // act
        const brush = PrettyQrBrush.transparent;

        // assert
        expect(brush.value, equals(0x00000000));
        expect(brush, isA<PrettyQrSolidBrush>());
      },
    );
  });

  group('PrettyQrBrush.from', () {
    test(
      'returns correct brush when source is Color',
      () {
        // arrange
        final source = testColor;

        // act
        final brush = PrettyQrBrush.from(source);

        // assert
        expect(brush.value, equals(source.value));
        expect(brush, isA<PrettyQrSolidBrush>());
      },
    );

    test(
      'returns identical brush when source is PrettyQrBrush',
      () {
        // arrange
        final source = PrettyQrBrush.from(testColor);

        // act
        final brush = PrettyQrBrush.from(source);

        // assert
        expect(identical(brush, source), isTrue);
      },
    );
  });

  group('PrettyQrBrush.lerp', () {
    test(
      'returns correct value when lerps from color to gradient',
      () {
        // arrange
        const instance1 = PrettyQrSolidBrush(0xFFFFFFFF);
        const instance2 = PrettyQrGradientBrush(
          gradient: LinearGradient(
            colors: [Color(0xFF000000), Color(0xFF7F7F7F)],
          ),
        );

        // act
        final lerpedBrush = PrettyQrBrush.lerp(instance1, instance2, 0.5);

        // assert
        expect(
          lerpedBrush,
          equals(
            const PrettyQrGradientBrush(
              gradient: LinearGradient(
                colors: [Color(0xFF7F7F7F), Color(0xFFBFBFBF)],
              ),
            ),
          ),
        );
      },
    );

    test(
      'returns correct value when lerps from gradient to color',
      () {
        // arrange
        const instance1 = PrettyQrGradientBrush(
          gradient: LinearGradient(
            colors: [Color(0xFF000000), Color(0xFF7F7F7F)],
          ),
        );
        const instance2 = PrettyQrSolidBrush(0xFFFFFFFF);

        // act
        final lerpedBrush = PrettyQrBrush.lerp(instance1, instance2, 0.5);

        // assert
        expect(
          lerpedBrush,
          equals(
            const PrettyQrGradientBrush(
              gradient: LinearGradient(
                colors: [Color(0xFF7F7F7F), Color(0xFFBFBFBF)],
              ),
            ),
          ),
        );
      },
    );

    test(
      'returns correct value when lerps from gradient to gradient',
      () {
        // arrange
        const instance1 = PrettyQrGradientBrush(
          gradient: LinearGradient(
            colors: [Color(0xFF000000), Color(0xFF7F7F7F)],
          ),
        );
        const instance2 = PrettyQrGradientBrush(
          gradient: LinearGradient(
            colors: [Color(0xFF7F7F7F), Color(0xFF000000)],
          ),
        );

        // act
        final lerpedBrush = PrettyQrBrush.lerp(instance1, instance2, 0.5);

        // assert
        expect(
          lerpedBrush,
          equals(
            const PrettyQrGradientBrush(
              gradient: LinearGradient(
                stops: [0, 1],
                colors: [Color(0xFF3F3F3F), Color(0xFF3F3F3F)],
              ),
            ),
          ),
        );
      },
    );

    test(
      'lerp returns correct value when destination is null and offset is '
      'less than 0.5',
      () {
        // arrange
        const brush = PrettyQrSolidBrush(0xFFFFFFFF);

        // act
        final lerpedBrush = PrettyQrBrush.lerp(brush, null, 0.1);

        // assert
        expect(identical(lerpedBrush, brush), isTrue);
      },
    );

    test(
      'lerp returns correct value when destination is null and offset is '
      'greater than or equal 0.5',
      () {
        // arrange
        const brush = PrettyQrSolidBrush(0xFFFFFFFF);

        // act
        final lerpedBrush = PrettyQrBrush.lerp(brush, null, 0.5);

        // assert
        expect(lerpedBrush, isNull);
      },
    );

    test(
      'lerp returns correct value when source is null and offset is '
      'less than 0.5',
      () {
        // arrange
        const brush = PrettyQrSolidBrush(0xFFFFFFFF);

        // act
        final lerpedBrush = PrettyQrBrush.lerp(null, brush, 0.1);

        // assert
        expect(lerpedBrush, isNull);
      },
    );

    test(
      'lerp returns correct value when source is null and offset is '
      'greater than or equal 0.5',
      () {
        // arrange
        const brush = PrettyQrSolidBrush(0xFFFFFFFF);

        // act
        final lerpedBrush = PrettyQrBrush.lerp(null, brush, 0.5);

        // assert
        expect(identical(lerpedBrush, brush), isTrue);
      },
    );
  });

  group('PrettyQrSolidBrush', () {
    test(
      'should be equal when instance is the same',
      () {
        // arrange
        final instance = PrettyQrSolidBrush(testColor.value);

        // assert
        expect(instance == instance, isTrue);
      },
    );

    test(
      'should be equal when instances are different',
      () {
        // arrange
        final instance1 = PrettyQrSolidBrush(testColor.value);
        final instance2 = PrettyQrSolidBrush(testColor.value);

        // assert
        expect(instance1 == instance2, isTrue);
      },
    );

    test(
      'should not be equal when runtime types are different',
      () {
        // arrange
        final instance1 = PrettyQrSolidBrush(testColor.value);
        final instance2 = _NotAPrettyQrSolidBrush(testColor.value);

        // assert
        expect(instance1 == instance2, isFalse);
      },
    );

    test(
      'should not be equal when colors are different',
      () {
        // arrange
        final instance1 = PrettyQrSolidBrush(testColor.value);
        final instance2 = PrettyQrSolidBrush(testColor.withOpacity(0.5).value);

        // assert
        expect(instance1 == instance2, isFalse);
      },
    );

    test(
      'should have same hashCode when values are equal',
      () {
        // arrange
        final instance1 = PrettyQrSolidBrush(testColor.value);
        final instance2 = PrettyQrSolidBrush(testColor.value);

        // assert
        expect(instance1.hashCode, equals(instance2.hashCode));
      },
    );

    group('toPaint', () {
      test(
        'returns correct Paint object',
        () {
          // arrange
          final brush = PrettyQrSolidBrush(testColor.value);

          // act
          final paint = brush.toPaint(
            Rect.zero,
            textDirection: null,
          );

          // assert
          expect(paint.color, equals(testColor));
          expect(paint.isAntiAlias, isTrue);
          expect(paint.style, equals(PaintingStyle.fill));
        },
      );

      testWidgets(
        'matches golden',
        (tester) async {
          // arrange
          const key = ValueKey('brush_test.solid');
          const brush = PrettyQrSolidBrush(0xFF80CBC4);

          // act
          await tester.pumpWidget(
            const RepaintBoundary(
              child: CustomPaint(
                key: key,
                painter: _TestBrushPainter(brush: brush),
              ),
            ),
          );

          // assert
          await expectLater(
            find.byKey(key),
            matchesGoldenFile('goldens/${key.value}.png'),
          );
        },
      );
    });
  });

  group('PrettyQrGradientBrush', () {
    // The default gradient to tests.
    final testGradient = LinearGradient(
      colors: [testColor, const Color(0xFFFF00FF)],
    );

    test(
      'should be equal when instance is the same',
      () {
        // arrange
        final instance = PrettyQrGradientBrush(gradient: testGradient);

        // assert
        expect(instance == instance, isTrue);
      },
    );

    test(
      'should be equal when instances are different',
      () {
        // arrange
        final instance1 = PrettyQrGradientBrush(gradient: testGradient);
        final instance2 = PrettyQrGradientBrush(gradient: testGradient);

        // assert
        expect(instance1 == instance2, isTrue);
      },
    );

    test(
      'should not be equal when runtime types are different',
      () {
        // arrange
        final instance1 = PrettyQrGradientBrush(gradient: testGradient);
        final instance2 = _NotAPrettyQrGradientBrush(gradient: testGradient);

        // assert
        expect(instance1 == instance2, isFalse);
      },
    );

    test(
      'should not be equal when gradients are different',
      () {
        // arrange
        final instance1 = PrettyQrGradientBrush(gradient: testGradient);
        const instance2 = PrettyQrGradientBrush(
          gradient: LinearGradient(
            colors: [Color(0xFFFFFF00), Color(0xFF00FFFF)],
          ),
        );

        // assert
        expect(instance1 == instance2, isFalse);
      },
    );

    test(
      'should have same hashCode when values are equal',
      () {
        // arrange
        final instance1 = PrettyQrGradientBrush(gradient: testGradient);
        final instance2 = PrettyQrGradientBrush(gradient: testGradient);

        // assert
        expect(instance1.hashCode, equals(instance2.hashCode));
      },
    );

    group('value', () {
      test(
        'return transparent when gradient colors is empty',
        () {
          // arrange
          const brush = PrettyQrGradientBrush(
            gradient: LinearGradient(colors: []),
          );

          // assert
          expect(brush.value, equals(0x00000000));
        },
      );

      test(
        'return first color from gradient when colors is not empty',
        () {
          // arrange
          final brush = PrettyQrGradientBrush(gradient: testGradient);

          // assert
          expect(brush.value, equals(testColor.value));
        },
      );
    });

    group('toPaint', () {
      // The variants to test in the brush golden test.
      final textDirectionVariants = ValueVariant({...TextDirection.values});

      test(
        'returns correct Paint object',
        () {
          // arrange
          const rect = Rect.fromLTWH(0, 0, 100, 200);
          final brush = PrettyQrGradientBrush(gradient: testGradient);

          // act
          final paint = brush.toPaint(
            rect,
            textDirection: TextDirection.rtl,
          );

          // assert
          expect(paint.color, equals(const Color(0xFF000000)));
          expect(paint.style, equals(PaintingStyle.fill));
          expect(paint.shader, isNotNull);
          expect(paint.isAntiAlias, isTrue);
        },
      );

      testWidgets(
        'matches golden',
        (tester) async {
          // arrange
          final textDirection = textDirectionVariants.currentValue!;
          final key = ValueKey('brush_test.gradient.${textDirection.name}');
          const brush = PrettyQrGradientBrush(
            gradient: LinearGradient(
              begin: AlignmentDirectional.centerStart,
              end: AlignmentDirectional.centerEnd,
              colors: [Color(0xFF009688), Color(0xFF80CBC4)],
            ),
          );

          // act
          await tester.pumpWidget(
            RepaintBoundary(
              child: CustomPaint(
                key: key,
                painter: _TestBrushPainter(
                  brush: brush,
                  textDirection: textDirection,
                ),
              ),
            ),
          );

          // assert
          await expectLater(
            find.byKey(key),
            matchesGoldenFile('goldens/${key.value}.png'),
          );
        },
        variant: textDirectionVariants,
      );
    });
  });
}
