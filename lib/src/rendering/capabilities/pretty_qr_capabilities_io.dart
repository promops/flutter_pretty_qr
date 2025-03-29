// ignore_for_file: prefer-static-class

import 'dart:io';

import 'package:meta/meta.dart';

/// The dart:io implementation of [isSkwasm].
///
/// This bool shouldn't be used outside of web.
@internal
bool get isSkwasm {
  throw UnimplementedError('isSkwasm is not implemented for dart:io.');
}

/// The dart:io implementation of [isCanvasKit].
///
/// This bool shouldn't be used outside of web.
@internal
bool get isCanvasKit {
  throw UnimplementedError('isCanvasKit is not implemented for dart:io.');
}

/// Attempts to indirectly detect whether the `Impeller` rendering engine has
/// fallback to no index buffer.
///
/// For more information, see impleller
/// [issue #126212](https://github.com/flutter/flutter/issues/126212) topic.
@internal
final isImpellerWithoutNoIndexBufferFallback = () {
  if (!Platform.isIOS) return false;
  final runtimeVersion = Platform.version;
  return runtimeVersion.startsWith('3.0') || runtimeVersion.startsWith('3.1');
}();
