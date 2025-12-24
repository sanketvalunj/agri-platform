import 'package:flutter/material.dart';
import '../../core/app_routes.dart';
import '../../shared/widgets/onboarding_progress.dart';
import '../../shared/widgets/agri_bottom_nav.dart';

/// BasicFarmProfileScreen
/// ----------------------
/// Purpose:
/// - Collect minimal farm details
/// - Error-proof using dropdowns
/// - Onboarding Step 3 of 4
///
/// UX Improvements:
/// - Dropdown-first (no typing errors)
/// - Default values
/// - Helpful farmer hints
/// - Large tap areas
///
/// NOTE:
/// - UI only
/// - No backend

class BasicFarmProfileScreen extends StatefulWidget {
  const BasicFarmProfileScreen({Key? key}) : super(key: key);

  @override
  State<BasicFarmProfileScreen> createState() =>
      _BasicFarmProfileScreenState();
}

class _BasicFarmProfileScreenState extends State<BasicFarmProfileScreen> {
  // ✅ Default values (error prevention)
  String selectedCrop = 'Rice';
  String landSize = '1–2 acres';
  String farmingType = 'Conventional';

  void _onProfileSaved(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white),
            SizedBox(width: 12),
            Text(
              'Farm profile saved',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
        backgroundColor: Colors.green.shade700,
        behavior: SnackBarBehavior.floating,
      ),
    );

    Future.delayed(const Duration(milliseconds: 700), () {
      Navigator.pushReplacementNamed(context, AppRoutes.home);
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// 🔢 Progress
              const OnboardingProgress(
                currentStep: 3,
                totalSteps: 4,
              ),

              const SizedBox(height: 32),

              Text(
                'Your Farm Details',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Colors.green.shade800,
                      fontWeight: FontWeight.bold,
                    ),
              ),

              const SizedBox(height: 12),

              Text(
                'Almost done! This helps us give you better advice',
                style: Theme.of(context).textTheme.bodyLarge,
              ),

              const SizedBox(height: 32),

              /// 🌾 Main Crop
              FarmDropdownField(
                label: 'Main Crop',
                hint: 'Most farmers select their main crop',
                icon: Icons.grass,
                value: selectedCrop,
                items: const [
                  'Rice',
                  'Wheat',
                  'Cotton',
                  'Sugarcane',
                  'Vegetables',
                ],
                onChanged: (val) =>
                    setState(() => selectedCrop = val),
              ),

              const SizedBox(height: 20),

              /// 📏 Land Size
              FarmDropdownField(
                label: 'Land Size',
                hint: 'Most farmers have 1–5 acres',
                icon: Icons.landscape,
                value: landSize,
                items: const [
                  'Less than 1 acre',
                  '1–2 acres',
                  '3–5 acres',
                  'More than 5 acres',
                ],
                onChanged: (val) =>
                    setState(() => landSize = val),
              ),

              const SizedBox(height: 20),

              /// 🌱 Farming Type
              FarmDropdownField(
                label: 'Farming Type',
                hint: 'Select your farming method',
                icon: Icons.eco,
                value: farmingType,
                items: const [
                  'Conventional',
                  'Organic',
                  'Mixed',
                ],
                onChanged: (val) =>
                    setState(() => farmingType = val),
              ),

              const Spacer(),

              /// ✅ Finish Setup
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton.icon(
                  onPressed: () => _onProfileSaved(context),
                  icon: const Icon(Icons.check, size: 28),
                  label: const Text(
                    'Finish Setup',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.shade700,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

      bottomNavigationBar: const AgriBottomNav(currentIndex: 0),
    );
  }
}

/// 🌾 Reusable Dropdown Field (Farmer-friendly)
class FarmDropdownField extends StatelessWidget {
  final String label;
  final String hint;
  final IconData icon;
  final String value;
  final List<String> items;
  final ValueChanged<String> onChanged;

  const FarmDropdownField({
    super.key,
    required this.label,
    required this.hint,
    required this.icon,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context)
              .textTheme
              .titleMedium
              ?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          initialValue: value,
          items: items
              .map(
                (e) => DropdownMenuItem(
                  value: e,
                  child: Text(e),
                ),
              )
              .toList(),
          onChanged: (val) => onChanged(val!),
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon),
            filled: true,
            fillColor: Colors.green.shade50,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ],
    );
  }
}
