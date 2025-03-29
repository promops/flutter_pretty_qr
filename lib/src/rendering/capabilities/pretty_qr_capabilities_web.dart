// ignore_for_file: prefer-static-class, prefer-prefixed-global-constants
// ignore_for_file: uri_does_not_exist, undefined_annotation, undefined_class, it's new JS and web interop solutions, flutter 3.10+.

import 'dart:js_interop';

import 'package:meta/meta.dart';

// These values are set by the engine. They are used to determine if the
// application is using skwasm.
@JS('window._flutter_skwasmInstance')
external JSAny? get _skwasmInstance;

// These values are set by the engine. They are used to determine if the
// application is using canvaskit.
@JS('window.flutterCanvasKit')
external JSAny? get _windowFlutterCanvasKit;

/// The `Impeller` rendering engine is not supported on the Web.
@internal
const isImpellerWithoutNoIndexBufferFallback = false;

/// The web implementation of [isSkwasm].
@internal
bool get isSkwasm {
  final contextValue = _skwasmInstance != null;
  const environmentValue = bool.fromEnvironment('dart.tool.dart2wasm');

  return contextValue || environmentValue;
}

/// The web implementation of [isCanvasKit].
@internal
bool get isCanvasKit {
  final contextValue = _windowFlutterCanvasKit != null;
  const environmentValue = bool.fromEnvironment('FLUTTER_WEB_USE_SKIA');

  return contextValue || environmentValue;
}
