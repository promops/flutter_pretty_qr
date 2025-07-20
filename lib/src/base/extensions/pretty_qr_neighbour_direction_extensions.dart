import 'package:pretty_qr_code/src/base/pretty_qr_neighbour_direction.dart';

/// Extensions that apply to [Set<PrettyQrNeighbourDirection>].
extension PrettyQrNeighbourDirectionSetExtension
    on Set<PrettyQrNeighbourDirection> {
  /// Returns `true` if the set containts `top` or `left` direction.
  @pragma('vm:prefer-inline')
  bool get atTopOrLeft => atTop || atLeft;

  /// Returns `true` if the set containts `top` or `right` direction.
  @pragma('vm:prefer-inline')
  bool get atTopOrRight => atTop || atRight;

  /// Returns `true` if the set containts `bottom` or `left` direction.
  @pragma('vm:prefer-inline')
  bool get atBottomOrLeft => atBottom || atLeft;

  /// Returns `true` if the set containts `bottom` or `right` direction.
  @pragma('vm:prefer-inline')
  bool get atBottomOrRight => atBottom || atRight;

  /// Returns `true` if the set containts `top` and `left` direction.
  @pragma('vm:prefer-inline')
  bool get atTopAndLeft => atTop && atLeft;

  /// Returns `true` if the set containts `top` and `right` direction.
  @pragma('vm:prefer-inline')
  bool get atTopAndRight => atTop && atRight;

  /// Returns `true` if the set containts `bottom` and `left` direction.
  @pragma('vm:prefer-inline')
  bool get atBottomAndLeft => atBottom && atLeft;

  /// Returns `true` if the set containts `bottom` and `right` direction.
  @pragma('vm:prefer-inline')
  bool get atBottomAndRight => atBottom && atRight;

  /// Returns `true` if the set containts `top`, `left`, `right` or `bottom`
  /// direction.
  @pragma('vm:prefer-inline')
  bool get hasClosest => atTop || atLeft || atRight || atBottom;

  /// Returns `true` if the set containts `topLeft` direction.
  @pragma('vm:prefer-inline')
  bool get atToptLeft => contains(PrettyQrNeighbourDirection.topLeft);

  /// Returns `true` if the set containts `top` direction.
  @pragma('vm:prefer-inline')
  bool get atTop => contains(PrettyQrNeighbourDirection.top);

  /// Returns `true` if the set containts `topRight` direction.
  @pragma('vm:prefer-inline')
  bool get atToptRight => contains(PrettyQrNeighbourDirection.topRight);

  /// Returns `true` if the set containts `left` direction.
  @pragma('vm:prefer-inline')
  bool get atLeft => contains(PrettyQrNeighbourDirection.left);

  /// Returns `true` if the set containts `right` direction.
  @pragma('vm:prefer-inline')
  bool get atRight => contains(PrettyQrNeighbourDirection.right);

  /// Returns `true` if the set containts `bottomLeft` direction.
  @pragma('vm:prefer-inline')
  bool get atBottomLeft => contains(PrettyQrNeighbourDirection.bottomLeft);

  /// Returns `true` if the set containts `bottom` direction.
  @pragma('vm:prefer-inline')
  bool get atBottom => contains(PrettyQrNeighbourDirection.bottom);

  /// Returns `true` if the set containts `bottomRight` direction.
  @pragma('vm:prefer-inline')
  bool get atBottomRight => contains(PrettyQrNeighbourDirection.bottomRight);
}
