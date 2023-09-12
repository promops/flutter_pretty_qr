import 'package:pretty_qr_code/src/base/pretty_qr_neighbour_direction.dart';

/// Extensions that apply to [Set<PrettyQrNeighbourDirection>].
extension PrettyQrNeighbourDirectionSetExt on Set<PrettyQrNeighbourDirection> {
  /// Returns `true` if the set containts `top` or `left` direction.
  bool get atTopOrLeft => atTop || atLeft;

  /// Returns `true` if the set containts `top` or `right` direction.
  bool get atTopOrRight => atTop || atRight;

  /// Returns `true` if the set containts `bottom` or `left` direction.
  bool get atBottomOrLeft => atBottom || atLeft;

  /// Returns `true` if the set containts `bottom` or `right` direction.
  bool get atBottomOrRight => atBottom || atRight;

  /// Returns `true` if the set containts `top` and `left` direction.
  bool get atTopAndLeft => atTop && atLeft;

  /// Returns `true` if the set containts `top` and `right` direction.
  bool get atTopAndRight => atTop && atRight;

  /// Returns `true` if the set containts `bottom` and `left` direction.
  bool get atBottomAndLeft => atBottom && atLeft;

  /// Returns `true` if the set containts `bottom` and `right` direction.
  bool get atBottomAndRight => atBottom && atRight;

  /// Returns `true` if the set containts `top`, `left`, `right` or `bottom`
  /// direction.
  bool get hasClosest => atTop || atLeft || atRight || atBottom;

  /// Returns `true` if the set containts `topLeft` direction.
  bool get atToptLeft => contains(PrettyQrNeighbourDirection.topLeft);

  /// Returns `true` if the set containts `top` direction.
  bool get atTop => contains(PrettyQrNeighbourDirection.top);

  /// Returns `true` if the set containts `topRight` direction.
  bool get atToptRight => contains(PrettyQrNeighbourDirection.topRight);

  /// Returns `true` if the set containts `left` direction.
  bool get atLeft => contains(PrettyQrNeighbourDirection.left);

  /// Returns `true` if the set containts `right` direction.
  bool get atRight => contains(PrettyQrNeighbourDirection.right);

  /// Returns `true` if the set containts `bottomLeft` direction.
  bool get atBottomLeft => contains(PrettyQrNeighbourDirection.bottomLeft);

  /// Returns `true` if the set containts `bottom` direction.
  bool get atBottom => contains(PrettyQrNeighbourDirection.bottom);

  /// Returns `true` if the set containts `bottomRight` direction.
  bool get atBottomRight => contains(PrettyQrNeighbourDirection.bottomRight);
}
