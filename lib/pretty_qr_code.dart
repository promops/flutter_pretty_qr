/// Flutter widgets that makes it easy to render QR codes.
library pretty_qr_code;

export 'package:qr/qr.dart';

// widgets
export 'src/widgets/pretty_qr.dart';
export 'src/widgets/pretty_qr_view.dart';
export 'src/widgets/pretty_qr_theme.dart';

export 'src/widgets/extensions/pretty_qr_decoration_theme_extension.dart';

// base
export 'src/base/pretty_qr_matrix.dart';
export 'src/base/pretty_qr_module.dart';
export 'src/base/pretty_qr_version.dart';
export 'src/base/pretty_qr_neighbour_direction.dart';

// painting
export 'src/painting/pretty_qr_brush.dart';
export 'src/painting/pretty_qr_shape.dart' hide clampDouble;
export 'src/painting/pretty_qr_quiet_zone.dart';

export 'src/painting/shapes/pretty_qr_dots_symbol.dart';
export 'src/painting/shapes/pretty_qr_rounded_symbol.dart';
export 'src/painting/shapes/pretty_qr_smooth_symbol.dart';
export 'src/painting/shapes/pretty_qr_squares_symbol.dart';

export 'src/painting/decoration/pretty_qr_decoration.dart';
export 'src/painting/decoration/pretty_qr_decoration_image.dart';
export 'src/painting/decoration/pretty_qr_decoration_tween.dart';

export 'src/painting/extensions/pretty_qr_image_extension.dart';
export 'src/painting/extensions/pretty_qr_module_extensions.dart';

// rendering
export 'src/rendering/pretty_qr_painting_context.dart';
export 'src/rendering/pretty_qr_render_capabilities.dart';
