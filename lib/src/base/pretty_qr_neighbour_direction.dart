import 'package:meta/meta.dart';

/// {@template pretty_qr_code.PrettyQrNeighbourDirection}
/// The direction in which there is a closest point.
/// {@endtemplate}
enum PrettyQrNeighbourDirection {
  /// The top left corner.
  topLeft(-1, -1),

  /// The point along the top edge.
  top(0, -1),

  /// The top right corner.
  topRight(1, -1),

  /// The point along the left edge.
  left(-1, 0),

  /// The point along the right edge.
  right(1, 0),

  /// The bottom left corner.
  bottomLeft(-1, 1),

  /// The point along the bottom edge.
  bottom(0, 1),

  /// The bottom right corner.
  bottomRight(1, 1);

  /// The distance fraction in the horizontal direction.
  @nonVirtual
  final int x;

  /// The distance fraction in the vertical direction.
  @nonVirtual
  final int y;

  /// {@macro pretty_qr_code.PrettyQrNeighbourDirection}
  @literal
  const PrettyQrNeighbourDirection(this.x, this.y);
}
