import 'package:flutter/material.dart';

/// OnboardingProgress
/// -------------------
/// Purpose:
/// - Show onboarding progress clearly to farmers
/// - Reduce confusion & anxiety
///
/// Example:
/// Step 2 of 4
///
/// UX Principles:
/// - Simple
/// - Reassuring
/// - No overload
///
/// Usage:
/// OnboardingProgress(
///   currentStep: 2,
///   totalSteps: 4,
/// )

class OnboardingProgress extends StatelessWidget {
  final int currentStep;
  final int totalSteps;

  const OnboardingProgress({
    Key? key,
    required this.currentStep,
    required this.totalSteps,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final progress = currentStep / totalSteps;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 🔢 Step text
        Text(
          'Step $currentStep of $totalSteps',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade800,
              ),
        ),

        const SizedBox(height: 8),

        // 📊 Progress bar
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 10,
            backgroundColor: Colors.grey.shade300,
            valueColor: AlwaysStoppedAnimation<Color>(
              Colors.green.shade700,
            ),
          ),
        ),

        const SizedBox(height: 8),

        // 💚 Confidence message
        Text(
          currentStep == totalSteps ? 'Almost done!' : 'Just a few steps to go',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey.shade600,
              ),
        ),
      ],
    );
  }
}
