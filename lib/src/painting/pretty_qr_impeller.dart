import 'dart:io';

import 'package:meta/meta.dart';
import 'package:flutter/foundation.dart';

/// {@template pretty_qr_code.painting.PrettyQrImpeller}
/// For more information, see impleller
/// [issue (#126212)](https://github.com/flutter/flutter/issues/126212).
/// {@endtemplate}
@sealed
abstract class PrettyQrImpeller {
  /// The default behavior is result of call [isImpellerDefaultEngine].
  /// You can set this to your own value to override this default behavior.
  // ignore: avoid-global-state
  static bool? enabled;

  /// Attempts to indirectly detect whether the `Impeller` rendering engine is
  /// enabled or not.
  @internal
  static bool get isImpellerDefaultEngine {
    if (kIsWeb) return false;
    return Platform.version.startsWith('3.') && Platform.isIOS;
  }
}
