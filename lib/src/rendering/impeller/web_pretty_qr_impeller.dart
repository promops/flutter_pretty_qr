// ignore_for_file: prefer-static-class, prefer-prefixed-global-constants, doesn't matter, it's for web support.

import 'package:meta/meta.dart';

/// The `Impeller` rendering engine is not supported on the Web.
@internal
const isImpellerWithoutNoIndexBufferFallback = false;
