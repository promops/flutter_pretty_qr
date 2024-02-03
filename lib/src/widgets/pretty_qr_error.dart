// ignore_for_file: no-object-declaration

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'dart:math' as math;

class PrettyQrErrorWidget extends StatelessWidget {
  final Object error;
  const PrettyQrErrorWidget({
    super.key,
    required this.error,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraints) {
        final dimension = math.min(
          constraints.maxWidth,
          constraints.maxHeight,
        );

        if (!kDebugMode) {
          return SizedBox.square(dimension: dimension);
        }

        return SizedBox.square(
          dimension: dimension,
          child: Stack(
            alignment: Alignment.center,
            children: [
              const Positioned.fill(
                child: Placeholder(
                  color: Color(0xCF8D021F),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: FittedBox(
                  child: Text(
                    '$error',
                    textAlign: TextAlign.center,
                    textDirection: TextDirection.ltr,
                    style: const TextStyle(
                      shadows: [Shadow(blurRadius: 1.0)],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
