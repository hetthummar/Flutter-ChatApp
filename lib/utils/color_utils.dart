import 'dart:ui';
import 'dart:math' as math;

class ColorUtils {
  Color getRandomColor() {
    return Color((math.Random().nextDouble() * 0xFFFFFF).toInt())
        .withOpacity(1.0);
  }
}
