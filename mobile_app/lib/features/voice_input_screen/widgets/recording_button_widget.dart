import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../shared/widgets/custom_icon_widget.dart';

/// Recording button widget with animated ripple effect and waveform visualization
/// Large touch target optimized for outdoor farm use
class RecordingButtonWidget extends StatelessWidget {
  final bool isRecording;
  final double amplitude;
  final Animation<double> rippleAnimation;
  final VoidCallback onTap;

  const RecordingButtonWidget({
    super.key,
    required this.isRecording,
    required this.amplitude,
    required this.rippleAnimation,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 70.w,
        height: 70.w,
        alignment: Alignment.center,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Animated ripple effect
            if (isRecording)
              AnimatedBuilder(
                animation: rippleAnimation,
                builder: (context, child) {
                  return Container(
                    width: 70.w * (1 + rippleAnimation.value * 0.3),
                    height: 70.w * (1 + rippleAnimation.value * 0.3),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: theme.colorScheme.error.withValues(
                        alpha: 0.1 * (1 - rippleAnimation.value),
                      ),
                    ),
                  );
                },
              ),

            // Waveform visualization
            if (isRecording)
              Container(
                width: 60.w,
                height: 60.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: theme.colorScheme.error.withValues(alpha: 0.1),
                ),
                child: CustomPaint(
                  painter: WaveformPainter(
                    amplitude: amplitude,
                    color: theme.colorScheme.error,
                  ),
                ),
              ),

            // Main recording button
            Container(
              width: 50.w,
              height: 50.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isRecording
                    ? theme.colorScheme.error
                    : theme.colorScheme.primary,
                boxShadow: [
                  BoxShadow(
                    color: (isRecording
                            ? theme.colorScheme.error
                            : theme.colorScheme.primary)
                        .withValues(alpha: 0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Center(
                child: CustomIconWidget(
                  iconName: isRecording ? 'stop' : 'mic',
                  color: Colors.white,
                  size: 15.w,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Custom painter for waveform visualization
class WaveformPainter extends CustomPainter {
  final double amplitude;
  final Color color;

  WaveformPainter({required this.amplitude, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withValues(alpha: 0.5)
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    final centerY = size.height / 2;
    final waveHeight = size.height * 0.3 * amplitude;

    // Draw multiple wave bars
    for (int i = 0; i < 8; i++) {
      final x = (size.width / 9) * (i + 1);
      final barHeight = waveHeight * (0.5 + (i % 3) * 0.25);

      canvas.drawLine(
        Offset(x, centerY - barHeight),
        Offset(x, centerY + barHeight),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(WaveformPainter oldDelegate) {
    return oldDelegate.amplitude != amplitude;
  }
}
