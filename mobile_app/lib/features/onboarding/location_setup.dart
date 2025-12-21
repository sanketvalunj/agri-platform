import 'package:flutter/material.dart';
import '../../core/app_routes.dart';
import '../../shared/widgets/onboarding_progress.dart';
import '../../shared/widgets/agri_bottom_nav.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

/// LocationSetupScreen
/// -------------------
/// Purpose:
/// - Collect farmer location safely
/// - Save location to backend
/// - Onboarding Step 2 of 4

class LocationSetupScreen extends StatefulWidget {
  const LocationSetupScreen({Key? key}) : super(key: key);

  @override
  State<LocationSetupScreen> createState() => _LocationSetupScreenState();
}

class _LocationSetupScreenState extends State<LocationSetupScreen> {
  /// Default selections
  String selectedState = 'Maharashtra';
  String selectedDistrict = 'Pune';
  String village = '';

  /// Language passed from previous screen
  String language = "en";

  /// Mock state → district mapping
  final Map<String, List<String>> stateDistricts = {
    'Maharashtra': ['Pune', 'Nashik', 'Nagpur', 'Kolhapur'],
    'Karnataka': ['Bengaluru', 'Mysuru', 'Belagavi'],
    'Tamil Nadu': ['Coimbatore', 'Salem', 'Madurai'],
    'Uttar Pradesh': ['Lucknow', 'Kanpur', 'Varanasi'],
  };

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // 🔹 Get language from previous screen
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    if (args != null && args.containsKey("language")) {
      language = args["language"];
    }
  }

  /// 🔹 Save location to backend
  Future<void> _saveLocation(BuildContext context) async {
    final body = {
      "user_id": "farmer_01", // TODO: replace with real user id
      "state": selectedState,
      "district": selectedDistrict,
      "village": village,
      "language": language,
    };

    try {
      final response = await http.post(
        Uri.parse("http://127.0.0.1:8000/api/user/location"), // iOS
        // Android: http://10.0.2.2:8000/api/user/location
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        _onLocationSaved(context);
      } else {
        _showError(context, "Failed to save location");
      }
    } catch (e) {
      _showError(context, "Backend not reachable");
    }
  }

  void _showError(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: Colors.red.shade700,
      ),
    );
  }

  void _onLocationSaved(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
<<<<<<< HEAD
        content: const Row(
          children: [
=======
        content: Row(
          children: const [
>>>>>>> ff9a281da14fd2211d5e027c78a4e6daf4f6262e
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

              /// 🏡 Village
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Village (Optional)',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.w600),
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
                  onPressed: () => _saveLocation(context),
                  icon: const Icon(Icons.arrow_forward, size: 28),
                  label: const Text(
                    'Continue',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
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

/// 🔽 Reusable Dropdown
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
          style: Theme.of(context)
              .textTheme
              .titleMedium
              ?.copyWith(fontWeight: FontWeight.w600),
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
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ],
    );
  }
}
