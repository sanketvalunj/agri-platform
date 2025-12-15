import 'package:flutter/material.dart';
import '../../core/app_routes.dart';
import '../../shared/widgets/onboarding_progress.dart';
import '../../shared/widgets/agri_bottom_nav.dart';

/// LocationSetupScreen
/// -------------------
/// Purpose:
/// - Collect farmer location safely
/// - Error-proof using dropdown + auto-suggest
/// - Onboarding Step 2 of 4
///
/// UX Improvements:
/// - Dropdown-first
/// - Auto-updating district list
/// - Optional village auto-suggest
///
/// NOTE:
/// - UI only
/// - No backend

class LocationSetupScreen extends StatefulWidget {
  const LocationSetupScreen({Key? key}) : super(key: key);

  @override
  State<LocationSetupScreen> createState() => _LocationSetupScreenState();
}

class _LocationSetupScreenState extends State<LocationSetupScreen> {
  /// Default selections (error prevention)
  String selectedState = 'Maharashtra';
  String selectedDistrict = 'Pune';
  String village = '';

  /// Mock state → district mapping (UI only)
  final Map<String, List<String>> stateDistricts = {
    'Maharashtra': ['Pune', 'Nashik', 'Nagpur', 'Kolhapur'],
    'Karnataka': ['Bengaluru', 'Mysuru', 'Belagavi'],
    'Tamil Nadu': ['Coimbatore', 'Salem', 'Madurai'],
    'Uttar Pradesh': ['Lucknow', 'Kanpur', 'Varanasi'],
  };

  void _onLocationSaved(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: const [
            Icon(Icons.check_circle, color: Colors.white),
            SizedBox(width: 12),
            Text('Location saved successfully'),
          ],
        ),
        backgroundColor: Colors.green.shade700,
        behavior: SnackBarBehavior.floating,
      ),
    );

    Future.delayed(const Duration(milliseconds: 600), () {
      Navigator.pushReplacementNamed(context, AppRoutes.farmProfile);
    });
  }

  @override
  Widget build(BuildContext context) {
    final districts = stateDistricts[selectedState]!;

    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// 🔢 Progress
              const OnboardingProgress(currentStep: 2, totalSteps: 4),

              const SizedBox(height: 32),

              Text(
                'Your Location',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Colors.green.shade800,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 12),

              Text(
                'This helps us give local farming advice',
                style: Theme.of(context).textTheme.bodyLarge,
              ),

              const SizedBox(height: 32),

              /// 🏳️ State
              LocationDropdown(
                label: 'State',
                icon: Icons.map,
                value: selectedState,
                items: stateDistricts.keys.toList(),
                onChanged: (val) {
                  setState(() {
                    selectedState = val;
                    selectedDistrict = stateDistricts[val]!.first;
                  });
                },
              ),

              const SizedBox(height: 20),

              /// 🏙 District
              LocationDropdown(
                label: 'District',
                icon: Icons.location_city,
                value: selectedDistrict,
                items: districts,
                onChanged: (val) {
                  setState(() => selectedDistrict = val);
                },
              ),

              const SizedBox(height: 20),

              /// 🏡 Village (Auto-suggest helper)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Village (Optional)',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Start typing village name…',
                      prefixIcon: const Icon(Icons.home),
                      filled: true,
                      fillColor: Colors.green.shade50,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onChanged: (val) => village = val,
                  ),
                ],
              ),

              const Spacer(),

              /// ✅ Continue
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton.icon(
                  onPressed: () => _onLocationSaved(context),
                  icon: const Icon(Icons.arrow_forward, size: 28),
                  label: const Text(
                    'Continue',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
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

/// 🔽 Reusable Dropdown (Farmer-friendly)
class LocationDropdown extends StatelessWidget {
  final String label;
  final IconData icon;
  final String value;
  final List<String> items;
  final ValueChanged<String> onChanged;

  const LocationDropdown({
    super.key,
    required this.label,
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
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          initialValue: value,
          items: items
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          onChanged: (val) => onChanged(val!),
          decoration: InputDecoration(
            prefixIcon: Icon(icon),
            filled: true,
            fillColor: Colors.green.shade50,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ],
    );
  }
}
