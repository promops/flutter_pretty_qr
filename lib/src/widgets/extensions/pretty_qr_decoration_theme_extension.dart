import 'package:pretty_qr_code/src/widgets/pretty_qr_theme.dart';
import 'package:pretty_qr_code/src/painting/decoration/pretty_qr_decoration.dart';

/// {@template pretty_qr_code.widgets.PrettyQrDecorationThemeExtension}
/// Extension that apply to QR code decoration.
/// {@endtemplate}
extension PrettyQrDecorationThemeExtension on PrettyQrDecoration? {
  /// Creates a new QR code decoration that is a combination of this decoration
  /// and the given [theme] values.
  ///
  /// Only null valued properties from this [PrettyQrDecoration] are replaced
  /// by the corresponding values from [theme].
  PrettyQrDecoration applyDefaults(PrettyQrTheme theme) {
    final decoration = this;
    if (decoration == null) return theme.decoration;

    return theme.decoration.copyWith(
      image: decoration.image,
      quietZone: decoration.quietZone,
      background: decoration.background,
      shape: decoration.shape,
    );
  }
}
