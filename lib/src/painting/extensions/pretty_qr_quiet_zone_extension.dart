import 'package:pretty_qr_code/src/painting/pretty_qr_quiet_zone.dart';
import 'package:pretty_qr_code/src/rendering/pretty_qr_painting_context.dart';

/// Extension that apply to QR code quiet zone.
extension PrettyQrQuietZoneExtension on PrettyQrQuietZone? {
  /// Returns the QR code quiet zone width.
  @pragma('vm:prefer-inline')
  double resolveWidth(PrettyQrPaintingContext context) {
    final self = this;
    if (self is PrettyQrPixelsQuietZone) {
      return self.value.clamp(0, context.boundsDimension / 4);
    } else if (self is PrettyQrModulesQuietZone) {
      final moduleSize = context.boundsDimension / (context.matrix.dimension);
      return (self.value * moduleSize).clamp(0, context.boundsDimension / 4);
    }
    return 0;
  }
}
