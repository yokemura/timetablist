import 'package:flutter/material.dart';

import '../../models/models.dart';
import '../timeline/time_layout.dart';

/// Vertical time scale from 0:00 to 30:00. Hours past 24:00 use a darker
/// background. Tick spacing follows [TimeLayout] (not a fixed px/hour).
class TimeRuler extends StatelessWidget {
  const TimeRuler({required this.layout, super.key});

  static const width = 48.0;

  final TimeLayout layout;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      width: width,
      height: layout.totalHeight,
      child: CustomPaint(
        painter: _TimeRulerPainter(
          layout: layout,
          labelStyle: theme.textTheme.labelSmall!.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
          lineColor: theme.colorScheme.outlineVariant,
          dayColor: theme.colorScheme.surfaceContainerLow,
          afterMidnightColor: theme.colorScheme.surfaceContainerHighest,
        ),
      ),
    );
  }
}

class _TimeRulerPainter extends CustomPainter {
  _TimeRulerPainter({
    required this.layout,
    required this.labelStyle,
    required this.lineColor,
    required this.dayColor,
    required this.afterMidnightColor,
  });

  final TimeLayout layout;
  final TextStyle labelStyle;
  final Color lineColor;
  final Color dayColor;
  final Color afterMidnightColor;

  @override
  void paint(Canvas canvas, Size size) {
    final midnightY = layout.yOf(TimeLayout.afterMidnight);
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, midnightY),
      Paint()..color = dayColor,
    );
    canvas.drawRect(
      Rect.fromLTWH(0, midnightY, size.width, size.height - midnightY),
      Paint()..color = afterMidnightColor,
    );

    final linePaint = Paint()
      ..color = lineColor
      ..strokeWidth = 1;

    var lastLabelY = -double.infinity;
    for (var hour = 0; hour <= TimelineLimits.maxHour; hour++) {
      final y = layout.yOf(TimelineTime.fromHoursAndMinutes(hour: hour, minute: 0));
      canvas.drawLine(Offset(size.width - 8, y), Offset(size.width, y), linePaint);

      final force = hour == 0 ||
          hour == TimeLayout.afterMidnight.hour ||
          hour == TimelineLimits.maxHour;
      if (!force && y - lastLabelY < 14) continue;

      final painter = TextPainter(
        text: TextSpan(text: '$hour:00', style: labelStyle),
        textDirection: TextDirection.ltr,
      )..layout(maxWidth: size.width - 10);
      var labelY = y - painter.height / 2;
      if (labelY < 0) labelY = 0;
      if (labelY + painter.height > size.height) {
        labelY = size.height - painter.height;
      }
      painter.paint(canvas, Offset(2, labelY));
      lastLabelY = y;
    }
  }

  @override
  bool shouldRepaint(covariant _TimeRulerPainter oldDelegate) =>
      oldDelegate.layout != layout ||
      oldDelegate.labelStyle != labelStyle ||
      oldDelegate.lineColor != lineColor ||
      oldDelegate.dayColor != dayColor ||
      oldDelegate.afterMidnightColor != afterMidnightColor;
}
