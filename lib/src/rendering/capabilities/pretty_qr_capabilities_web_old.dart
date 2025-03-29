// ignore_for_file: prefer-static-class, prefer-prefixed-global-constants
// ignore_for_file: avoid_web_libraries_in_flutter, it's for web support.

import 'dart:js';

import 'package:meta/meta.dart';

/// The `Impeller` rendering engine is not supported on the Web.
@internal
const isImpellerWithoutNoIndexBufferFallback = false;

/// The web implementation of [isSkwasm].
@internal
bool get isSkwasm {
  final contextValue = context['_flutter_skwasmInstance'] != null;
  const environmentValue = bool.fromEnvironment('dart.tool.dart2wasm');

  return contextValue || environmentValue;
}

/// The web implementation of [isCanvasKit].
@internal
bool get isCanvasKit {
  final contextValue = context['flutterCanvasKit'] != null;
  const environmentValue = bool.fromEnvironment('FLUTTER_WEB_USE_SKIA');

  return contextValue || environmentValue;
}
