import 'package:flutter/material.dart';
import '../../core/app_routes.dart';
import '../../shared/widgets/onboarding_progress.dart';

/// LanguageSelectionScreen
/// -----------------------
/// Purpose:
/// - Step 1 of onboarding
/// - Let farmers choose their preferred language
///
/// UX Principles:
/// - Very simple
/// - Large buttons
/// - Icons + text
/// - Confidence building
///
/// NOTE:
/// - UI only
/// - Language logic will be added later

class LanguageSelectionScreen extends StatelessWidget {
  const LanguageSelectionScreen({Key? key}) : super(key: key);

  void _onLanguageSelected(BuildContext context) {
    // Farmer reassurance
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white),
            SizedBox(width: 12),
            Text('Language selected'),
          ],
        ),
        backgroundColor: Colors.green.shade700,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );

    Future.delayed(const Duration(milliseconds: 600), () {
      Navigator.pushReplacementNamed(context, AppRoutes.location);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 🔢 Progress (Step 1 of 4)
              const OnboardingProgress(
                currentStep: 1,
                totalSteps: 4,
              ),

              const SizedBox(height: 32),

              // Title
              Text(
                'Choose Your Language',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Colors.green.shade800,
                      fontWeight: FontWeight.bold,
                    ),
              ),

              const SizedBox(height: 12),

              // Helper text
              Text(
                'Select the language you are comfortable with',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.grey.shade800,
                    ),
              ),

              const SizedBox(height: 32),

              // Language options
              Expanded(
                child: ListView(
                  children: [
                    LanguageButton(
                      label: 'English',
                      onTap: () => _onLanguageSelected(context),
                    ),
                    LanguageButton(
                      label: 'हिंदी (Hindi)',
                      onTap: () => _onLanguageSelected(context),
                    ),
                    LanguageButton(
                      label: 'मराठी (Marathi)',
                      onTap: () => _onLanguageSelected(context),
                    ),
                    LanguageButton(
                      label: 'தமிழ் (Tamil)',
                      onTap: () => _onLanguageSelected(context),
                    ),
                    LanguageButton(
                      label: 'తెలుగు (Telugu)',
                      onTap: () => _onLanguageSelected(context),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// LanguageButton
/// --------------
/// Large, touch-friendly button for language selection
class LanguageButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const LanguageButton({
    Key? key,
    required this.label,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: SizedBox(
        height: 60, // 👈 Big tap area
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: onTap,
          icon: const Icon(Icons.language, size: 28, color: Colors.white),
          label: Text(
            label,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green.shade700,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            elevation: 2,
          ),
        ),
      ),
    );
  }
}
