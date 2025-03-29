// ignore_for_file: prefer-static-class, doesn't matter, it's for web support.

import 'dart:io';

import 'package:meta/meta.dart';

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
