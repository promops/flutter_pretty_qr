// ignore_for_file: avoid-global-state, experimental settings, not to be changed by users.

import 'package:meta/meta.dart';
import 'package:flutter/foundation.dart';

import 'package:pretty_qr_code/src/rendering/capabilities/pretty_qr_capabilities_io.dart'
    if (dart.library.js_interop) 'package:pretty_qr_code/src/rendering/capabilities/pretty_qr_capabilities_web.dart'
    if (dart.library.js_util) 'package:pretty_qr_code/src/rendering/capabilities/pretty_qr_capabilities_web_old.dart'
    as capabilities;

/// {@template pretty_qr_code.rendering.PrettyQrRenderExperiments}
/// To enable experiments related to rendering QR codes, edit the desired flags.
/// {@endtemplate}
@sealed
abstract class PrettyQrRenderCapabilities {
  /// Whether QR code render object repaints separately from its parent.
  ///
  /// Defaults to `true`.
  ///
  /// See [RepaintBoundary] for more information about how repaint boundaries
  /// function.
  static bool enableRepaintBoundary = true;

  /// Whether the QR code complex paths should be subdivided.
  ///
  /// Defaults to [capabilities.isImpellerWithoutNoIndexBufferFallback].
  static bool needsAvoidComplexPaths =
      capabilities.isImpellerWithoutNoIndexBufferFallback;

  /// Whether to render nested images when exporting to an image.
  static bool enableExportNestedImage =
      !kIsWeb || capabilities.isCanvasKit || capabilities.isSkwasm;
}
