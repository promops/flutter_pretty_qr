// ignore_for_file: avoid-global-state, experimental settings, not to be changed by users.

import 'package:meta/meta.dart';

import 'package:pretty_qr_code/src/rendering/impeller/io_pretty_qr_impeller.dart'
    if (dart.library.html) 'package:pretty_qr_code/src/rendering/impeller/web_pretty_qr_impeller.dart';

/// {@template pretty_qr_code.rendering.PrettyQrRenderExperiments}
/// To enable experiments related to rendering QR codes, edit the desired flags.
/// {@endtemplate}
@sealed
abstract class PrettyQrRenderExperiments {
  /// Whether QR code render object repaints separately from its parent.
  ///
  /// Defaults to `true`.
  ///
  /// See [RepaintBoundary] for more information about how repaint boundaries
  /// function.
  static bool enableRepaintBoundary = true;

  /// Whether the QR code complex paths should be subdivided.
  ///
  /// Defaults to [isImpellerWithoutNoIndexBufferFallback].
  static bool needsAvoidComplexPaths = isImpellerWithoutNoIndexBufferFallback;
}
