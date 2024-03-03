import 'package:meta/meta.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:pretty_qr_code/src/painting/extensions/pretty_qr_brush_extensions.dart';

class _TestUnknownGradient extends Gradient with Fake {
  @literal
  const _TestUnknownGradient({required super.colors});
}

void main() {
  group('PrettyQrBaseGradientExtension', () {
    group('lerpToColor', () {
      test(
        'returns correct value when lerps linear gradient to color',
        () {
          // arrange
          const color = Color(0xFFFFFFFF);
          const gradient = LinearGradient(
            colors: [Color(0xFF000000), Color(0xFF7F7F7F)],
          );

          // act
          final lerpedColor = gradient.lerpToColor(color, 0.5);

          // assert
          expect(
            lerpedColor,
            equals(
              const LinearGradient(
                colors: [Color(0xFF7F7F7F), Color(0xFFBFBFBF)],
              ),
            ),
          );
        },
      );

      test(
        'returns correct value when lerps radial gradient to color',
        () {
          // arrange
          const color = Color(0xFFFFFFFF);
          const gradient = RadialGradient(
            colors: [Color(0xFF000000), Color(0xFF7F7F7F)],
          );

          // act
          final lerpedColor = gradient.lerpToColor(color, 0.5);

          // assert
          expect(
            lerpedColor,
            equals(
              const RadialGradient(
                colors: [Color(0xFF7F7F7F), Color(0xFFBFBFBF)],
              ),
            ),
          );
        },
      );

      test(
        'returns correct value when lerps sweep gradient to color',
        () {
          // arrange
          const color = Color(0xFFFFFFFF);
          const gradient = SweepGradient(
            colors: [Color(0xFF000000), Color(0xFF7F7F7F)],
          );

          // act
          final lerpedColor = gradient.lerpToColor(color, 0.5);

          // assert
          expect(
            lerpedColor,
            equals(
              const SweepGradient(
                colors: [Color(0xFF7F7F7F), Color(0xFFBFBFBF)],
              ),
            ),
          );
        },
      );

      test(
        'lerp returns correct value when lerps unknown gradient to color and '
        'offset is less than 0.5',
        () {
          // arrange
          const color = Color(0xFFFFFFFF);
          const gradient = _TestUnknownGradient(
            colors: [Color(0xFF000000), Color(0xFF7F7F7F)],
          );

          // act
          final lerpedColor = gradient.lerpToColor(color, 0.1);

          // assert
          expect(identical(lerpedColor, gradient), isTrue);
        },
      );

      test(
        'lerp returns correct value when lerps unknown gradient to color and '
        'offset is greater than or equal 0.5',
        () {
          // arrange
          const color = Color(0xFFFFFFFF);
          const gradient = _TestUnknownGradient(
            colors: [Color(0xFF000000), Color(0xFF7F7F7F)],
          );

          // act
          final lerpedColor = gradient.lerpToColor(color, 0.5);

          // assert
          expect(
            lerpedColor,
            equals(const LinearGradient(colors: [color, color])),
          );
        },
      );
    });
  });

  group('PrettyQrColorBaseGradientExtension', () {
    group('lerpToGradient', () {
      test(
        'returns correct value when lerps color to linear gradient',
        () {
          // arrange
          const color = Color(0xFFFFFFFF);
          const gradient = LinearGradient(
            colors: [Color(0xFF000000), Color(0xFF7F7F7F)],
          );

          // act
          final lerpedColor = color.lerpToGradient(gradient, 0.5);

          // assert
          expect(
            lerpedColor,
            equals(
              const LinearGradient(
                colors: [Color(0xFF7F7F7F), Color(0xFFBFBFBF)],
              ),
            ),
          );
        },
      );

      test(
        'returns correct value when lerps color to radial gradient',
        () {
          // arrange
          const color = Color(0xFFFFFFFF);
          const gradient = RadialGradient(
            colors: [Color(0xFF000000), Color(0xFF7F7F7F)],
          );

          // act
          final lerpedColor = color.lerpToGradient(gradient, 0.5);

          // assert
          expect(
            lerpedColor,
            equals(
              const RadialGradient(
                colors: [Color(0xFF7F7F7F), Color(0xFFBFBFBF)],
              ),
            ),
          );
        },
      );

      test(
        'returns correct value when lerps color to sweep gradient',
        () {
          // arrange
          const color = Color(0xFFFFFFFF);
          const gradient = SweepGradient(
            colors: [Color(0xFF000000), Color(0xFF7F7F7F)],
          );

          // act
          final lerpedColor = color.lerpToGradient(gradient, 0.5);

          // assert
          expect(
            lerpedColor,
            equals(
              const SweepGradient(
                colors: [Color(0xFF7F7F7F), Color(0xFFBFBFBF)],
              ),
            ),
          );
        },
      );

      test(
        'lerp returns correct value when lerps color to unknown gradient and '
        'offset is less than 0.5',
        () {
          // arrange
          const color = Color(0xFFFFFFFF);
          const gradient = _TestUnknownGradient(
            colors: [Color(0xFF000000), Color(0xFF7F7F7F)],
          );

          // act
          final lerpedColor = color.lerpToGradient(gradient, 0.1);

          // assert
          expect(
            lerpedColor,
            equals(const LinearGradient(colors: [color, color])),
          );
        },
      );

      test(
        'lerp returns correct value when lerps color to unknown gradient and '
        'offset is greater than or equal 0.5',
        () {
          // arrange
          const color = Color(0xFFFFFFFF);
          const gradient = _TestUnknownGradient(
            colors: [Color(0xFF000000), Color(0xFF7F7F7F)],
          );

          // act
          final lerpedColor = color.lerpToGradient(gradient, 0.5);

          // assert
          expect(identical(lerpedColor, gradient), isTrue);
        },
      );
    });
  });
}
