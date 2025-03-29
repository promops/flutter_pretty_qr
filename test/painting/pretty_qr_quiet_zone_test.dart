import 'dart:math';

import 'package:flutter_test/flutter_test.dart';

import 'package:pretty_qr_code/src/painting/pretty_qr_quiet_zone.dart';

void main() {
  group('PrettyQrQuietZone.zero', () {
    test(
      'returns correct quiet zone with zero width',
      () {
        // act
        const quietZone = PrettyQrQuietZone.zero;

        // assert
        expect(quietZone.value, equals(0));
        expect(quietZone, isA<PrettyQrModulesQuietZone>());
      },
    );
  });

  group('PrettyQrQuietZone.standart', () {
    test(
      'returns correct quiet zone with standart width',
      () {
        // act
        const quietZone = PrettyQrQuietZone.standart;

        // assert
        expect(quietZone.value, equals(4));
        expect(quietZone, isA<PrettyQrModulesQuietZone>());
      },
    );
  });

  group('PrettyQrQuietZone.pixels', () {
    test(
      'returns correct quiet zone object',
      () {
        // arrange
        final value = Random().nextDouble();

        // act
        final quietZone = PrettyQrQuietZone.pixels(value);

        // assert
        expect(quietZone.value, equals(value));
        expect(quietZone, isA<PrettyQrPixelsQuietZone>());
      },
    );
  });

  group('PrettyQrQuietZone.modules', () {
    test(
      'returns correct quiet zone object',
      () {
        // arrange
        final value = Random().nextInt(256);

        // act
        final quietZone = PrettyQrQuietZone.modules(value);

        // assert
        expect(quietZone.value, equals(value));
        expect(quietZone, isA<PrettyQrModulesQuietZone>());
      },
    );
  });

  group('PrettyQrQuietZone.lerp', () {
    test(
      'lerp returns correct value when source and destination identical',
      () {
        // arrange
        const source = PrettyQrQuietZone.modules(1);

        // act
        final lerpedQuietZone = PrettyQrQuietZone.lerp(
          source,
          source,
          0.1,
        );

        // assert
        expect(identical(lerpedQuietZone, source), isTrue);
      },
    );

    test(
      'lerp returns source value when offset equals to 0.0',
      () {
        // arrange
        const source = PrettyQrQuietZone.modules(1);
        const destination = PrettyQrQuietZone.modules(2);

        // act
        final lerpedQuietZone = PrettyQrQuietZone.lerp(
          source,
          destination,
          0.0,
        );

        // assert
        expect(identical(lerpedQuietZone, source), isTrue);
      },
    );

    test(
      'lerp returns destination value when destination equals to 1.0',
      () {
        // arrange
        const source = PrettyQrQuietZone.modules(1);
        const destination = PrettyQrQuietZone.modules(2);

        // act
        final lerpedQuietZone = PrettyQrQuietZone.lerp(
          source,
          destination,
          1.0,
        );

        // assert
        expect(identical(lerpedQuietZone, destination), isTrue);
      },
    );

    test(
      'lerp returns correct value when source is null and destination is '
      'pixels based quiet zone',
      () {
        // arrange
        const offset = 0.6;
        const destination = PrettyQrPixelsQuietZone(256);

        // act
        final lerpedQuietZone = PrettyQrQuietZone.lerp(
          null,
          destination,
          offset,
        );

        // assert
        expect(
          lerpedQuietZone,
          equals(PrettyQrPixelsQuietZone(destination.value * offset)),
        );
      },
    );

    test(
      'lerp returns correct value when source is zero and destination is '
      'pixels based quiet zone',
      () {
        // arrange
        const offset = 0.6;
        const source = PrettyQrModulesQuietZone(0);
        const destination = PrettyQrPixelsQuietZone(256);

        // act
        final lerpedQuietZone = PrettyQrQuietZone.lerp(
          source,
          destination,
          offset,
        );

        // assert
        expect(
          lerpedQuietZone,
          equals(PrettyQrPixelsQuietZone(destination.value * offset)),
        );
      },
    );

    test(
      'lerp returns correct value when destination is null and source is '
      'pixels based quiet zone',
      () {
        // arrange
        const offset = 0.6;
        const source = PrettyQrPixelsQuietZone(256);

        // act
        final lerpedQuietZone = PrettyQrQuietZone.lerp(
          source,
          null,
          offset,
        );

        // assert
        expect(
          lerpedQuietZone,
          equals(PrettyQrQuietZone.pixels(source.value * (1.0 - offset))),
        );
      },
    );

    test(
      'lerp returns correct value when destination is zero and source is '
      'pixels based quiet zone',
      () {
        // arrange
        const offset = 0.6;
        const source = PrettyQrPixelsQuietZone(256);
        const destination = PrettyQrModulesQuietZone(0);

        // act
        final lerpedQuietZone = PrettyQrQuietZone.lerp(
          source,
          destination,
          offset,
        );

        // assert
        expect(
          lerpedQuietZone,
          equals(PrettyQrPixelsQuietZone(source.value * (1.0 - offset))),
        );
      },
    );

    test(
      'lerp returns correct value when source and destination are pixels based '
      'quiet zones',
      () {
        // arrange
        const offset = 0.6;
        const source = PrettyQrPixelsQuietZone(64);
        const destination = PrettyQrPixelsQuietZone(256);

        // act
        final lerpedQuietZone = PrettyQrQuietZone.lerp(
          source,
          destination,
          offset,
        );

        // assert
        expect(
          lerpedQuietZone,
          equals(PrettyQrPixelsQuietZone(
            source.value * (1.0 - offset) + destination.value * offset,
          )),
        );
      },
    );

    test(
      'lerp returns correct value when source is module based quiet zone and '
      'offset is less than 0.5',
      () {
        // arrange
        const source = PrettyQrModulesQuietZone(1);
        const destination = PrettyQrPixelsQuietZone(2);

        // act
        final lerpedQuietZone = PrettyQrQuietZone.lerp(
          source,
          destination,
          0.4,
        );

        // assert
        expect(identical(lerpedQuietZone, source), isTrue);
      },
    );

    test(
      'lerp returns correct value when source is module based quiet zone and '
      'offset is greater than or equal 0.5',
      () {
        // arrange
        const source = PrettyQrModulesQuietZone(1);
        const destination = PrettyQrPixelsQuietZone(2);

        // act
        final lerpedQuietZone = PrettyQrQuietZone.lerp(
          source,
          destination,
          0.6,
        );

        // assert
        expect(identical(lerpedQuietZone, destination), isTrue);
      },
    );

    test(
      'lerp returns correct value when destination is module based quiet zone '
      'and offset is less than 0.5',
      () {
        // arrange
        const source = PrettyQrPixelsQuietZone(1);
        const destination = PrettyQrModulesQuietZone(2);

        // act
        final lerpedQuietZone = PrettyQrQuietZone.lerp(
          source,
          destination,
          0.4,
        );

        // assert
        expect(identical(lerpedQuietZone, source), isTrue);
      },
    );

    test(
      'lerp returns correct value when destination is module based quiet zone '
      'and offset is greater than or equal 0.5',
      () {
        // arrange
        const source = PrettyQrPixelsQuietZone(1);
        const destination = PrettyQrModulesQuietZone(2);

        // act
        final lerpedQuietZone = PrettyQrQuietZone.lerp(
          source,
          destination,
          0.6,
        );

        // assert
        expect(identical(lerpedQuietZone, destination), isTrue);
      },
    );
  });

  group('PrettyQrPixelsQuietZone', () {
    test(
      'should be equal when instance is the same',
      () {
        // arrange
        final value = Random().nextDouble();
        final instance = PrettyQrPixelsQuietZone(value);

        // assert
        expect(instance == instance, isTrue);
      },
    );

    test(
      'should be equal when instances are different',
      () {
        // arrange
        final value = Random().nextDouble();
        final instance1 = PrettyQrPixelsQuietZone(value);
        final instance2 = PrettyQrPixelsQuietZone(value);

        // assert
        expect(instance1 == instance2, isTrue);
      },
    );

    test(
      'should not be equal when values are different',
      () {
        // arrange
        final value = Random().nextDouble();
        final instance1 = PrettyQrPixelsQuietZone(value);
        final instance2 = PrettyQrPixelsQuietZone(value + 1);

        // assert
        expect(instance1 == instance2, isFalse);
      },
    );

    test(
      'should have same hashCode when values are equal',
      () {
        // arrange
        final value = Random().nextDouble();
        final instance1 = PrettyQrPixelsQuietZone(value);
        final instance2 = PrettyQrPixelsQuietZone(value);

        // assert
        expect(instance1.hashCode, equals(instance2.hashCode));
      },
    );
  });
  group('PrettyQrModulesQuietZone', () {
    test(
      'should be equal when instance is the same',
      () {
        // arrange
        final value = Random().nextInt(256);
        final instance = PrettyQrModulesQuietZone(value);

        // assert
        expect(instance == instance, isTrue);
      },
    );

    test(
      'should be equal when instances are different',
      () {
        // arrange
        final value = Random().nextInt(256);
        final instance1 = PrettyQrModulesQuietZone(value);
        final instance2 = PrettyQrModulesQuietZone(value);

        // assert
        expect(instance1 == instance2, isTrue);
      },
    );

    test(
      'should not be equal when values are different',
      () {
        // arrange
        final value = Random().nextInt(256);
        final instance1 = PrettyQrModulesQuietZone(value);
        final instance2 = PrettyQrModulesQuietZone(value + 1);

        // assert
        expect(instance1 == instance2, isFalse);
      },
    );

    test(
      'should have same hashCode when values are equal',
      () {
        // arrange
        final value = Random().nextInt(256);
        final instance1 = PrettyQrModulesQuietZone(value);
        final instance2 = PrettyQrModulesQuietZone(value);

        // assert
        expect(instance1.hashCode, equals(instance2.hashCode));
      },
    );
  });
}
