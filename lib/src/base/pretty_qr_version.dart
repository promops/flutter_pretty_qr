import 'package:meta/meta.dart';

/// {@template pretty_qr_code.base.PrettyQrVersion}
/// The QR Code version numbers (1 - 40).
/// {@endtemplate}
enum PrettyQrVersion {
  /// The QR Code version 1 (21x21 modules).
  version01(1, alignmentPatternsPlacement: {}),

  /// The QR Code version 2 (25x25 modules).
  version02(2, alignmentPatternsPlacement: {6, 18}),

  /// The QR Code version 3 (29x29 modules).
  version03(3, alignmentPatternsPlacement: {6, 22}),

  /// The QR Code version 4 (33x33 modules).
  version04(4, alignmentPatternsPlacement: {6, 26}),

  /// The QR Code version 5 (37x37 modules).
  version05(5, alignmentPatternsPlacement: {6, 30}),

  /// The QR Code version 6 (41x41 modules).
  version06(6, alignmentPatternsPlacement: {6, 34}),

  /// The QR Code version 7 (45x45 modules).
  version07(7, alignmentPatternsPlacement: {6, 22, 38}),

  /// The QR Code version 8 (49x49 modules).
  version08(8, alignmentPatternsPlacement: {6, 24, 42}),

  /// The QR Code version 9 (53x53 modules).
  version09(9, alignmentPatternsPlacement: {6, 26, 46}),

  /// The QR Code version 10 (57x57 modules).
  version10(10, alignmentPatternsPlacement: {6, 28, 50}),

  /// The QR Code version 11 (61x61 modules).
  version11(11, alignmentPatternsPlacement: {6, 30, 54}),

  /// The QR Code version 12 (65x65 modules).
  version12(12, alignmentPatternsPlacement: {6, 32, 58}),

  /// The QR Code version 13 (69x69 modules).
  version13(13, alignmentPatternsPlacement: {6, 34, 62}),

  /// The QR Code version 14 (73x73 modules).
  version14(14, alignmentPatternsPlacement: {6, 26, 46, 66}),

  /// The QR Code version 15 (77x77 modules).
  version15(15, alignmentPatternsPlacement: {6, 26, 48, 70}),

  /// The QR Code version 16 (81x81 modules).
  version16(16, alignmentPatternsPlacement: {6, 26, 50, 74}),

  /// The QR Code version 17 (85x85 modules).
  version17(17, alignmentPatternsPlacement: {6, 30, 54, 78}),

  /// The QR Code version 18 (89x89 modules).
  version18(18, alignmentPatternsPlacement: {6, 30, 56, 82}),

  /// The QR Code version 19 (93x93 modules).
  version19(19, alignmentPatternsPlacement: {6, 30, 58, 86}),

  /// The QR Code version 20 (97x97 modules).
  version20(20, alignmentPatternsPlacement: {6, 34, 62, 90}),

  /// The QR Code version 21 (101x101 modules).
  version21(21, alignmentPatternsPlacement: {6, 28, 50, 72, 94}),

  /// The QR Code version 22 (105x105 modules).
  version22(22, alignmentPatternsPlacement: {6, 26, 50, 74, 98}),

  /// The QR Code version 23 (109x109 modules).
  version23(23, alignmentPatternsPlacement: {6, 30, 54, 78, 102}),

  /// The QR Code version 24 (113x113 modules).
  version24(24, alignmentPatternsPlacement: {6, 28, 54, 80, 106}),

  /// The QR Code version 25 (117x117 modules).
  version25(25, alignmentPatternsPlacement: {6, 32, 58, 84, 110}),

  /// The QR Code version 26 (121x121 modules).
  version26(26, alignmentPatternsPlacement: {6, 30, 58, 86, 114}),

  /// The QR Code version 27 (125x125 modules).
  version27(27, alignmentPatternsPlacement: {6, 34, 62, 90, 118}),

  /// The QR Code version 28 (129x129 modules).
  version28(28, alignmentPatternsPlacement: {6, 26, 50, 74, 98, 122}),

  /// The QR Code version 29 (133x133 modules).
  version29(29, alignmentPatternsPlacement: {6, 30, 54, 78, 102, 126}),

  /// The QR Code version 30 (137x137 modules).
  version30(30, alignmentPatternsPlacement: {6, 26, 52, 78, 104, 130}),

  /// The QR Code version 31 (141x141 modules).
  version31(31, alignmentPatternsPlacement: {6, 30, 56, 82, 108, 134}),

  /// The QR Code version 32 (145x145 modules).
  version32(32, alignmentPatternsPlacement: {6, 34, 60, 86, 112, 138}),

  /// The QR Code version 33 (149x149 modules).
  version33(33, alignmentPatternsPlacement: {6, 30, 58, 86, 114, 142}),

  /// The QR Code version 34 (153x153 modules).
  version34(34, alignmentPatternsPlacement: {6, 34, 62, 90, 118, 146}),

  /// The QR Code version 35 (157x157 modules).
  version35(35, alignmentPatternsPlacement: {6, 30, 54, 78, 102, 126, 150}),

  /// The QR Code version 36 (161x161 modules).
  version36(36, alignmentPatternsPlacement: {6, 24, 50, 76, 102, 128, 154}),

  /// The QR Code version 37 (165x165 modules).
  version37(37, alignmentPatternsPlacement: {6, 28, 54, 80, 106, 132, 158}),

  /// The QR Code version 38 (169x169 modules).
  version38(38, alignmentPatternsPlacement: {6, 32, 58, 84, 110, 136, 162}),

  /// The QR Code version 39 (173x173 modules).
  version39(39, alignmentPatternsPlacement: {6, 26, 54, 82, 110, 138, 166}),

  /// The QR Code version 40 (177x177 modules).
  version40(40, alignmentPatternsPlacement: {6, 30, 58, 86, 114, 142, 170});

  /// The raw value of the [PrettyQrVersion].
  @nonVirtual
  final int value;

  /// {@template pretty_qr_code.base.PrettyQrVersion.dimension}
  /// The size (side length) of the QR Code matrix.
  /// {@endtemplate}
  @nonVirtual
  final int dimension;

  /// The Alignment Pattern locations.
  @nonVirtual
  final Set<int> alignmentPatternsPlacement;

  /// {@macro pretty_qr_code.base.PrettyQrVersion}
  @literal
  const PrettyQrVersion(
    this.value, {
    required this.alignmentPatternsPlacement,
  }) : dimension = value * 4 + 17;

  /// Returns [PrettyQrVersion] corresponding to the passed [value].
  factory PrettyQrVersion.of(
    final int value,
  ) {
    for (final version in values) {
      if (version.value == value) return version;
    }

    throw ArgumentError.value(
      value,
      'value',
      'No QR Code version corresponding to the passed value',
    );
  }
}
