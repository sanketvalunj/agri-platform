import 'package:flutter/material.dart';
import '../../core/app_routes.dart';
import '../../shared/widgets/agri_bottom_nav.dart';

/// CarbonInputScreen
/// ------------------
/// Purpose:
/// - Collect simple farming activity data for carbon calculation
///
/// UX Enhancements:
/// - Dropdowns instead of typing
/// - Default values to avoid blank forms
/// - Helpful hints for farmers
/// - One clear action
/// - Scroll-safe layout
///
/// NOTE:
/// - UI only
/// - No backend / validation

class CarbonInputScreen extends StatefulWidget {
  const CarbonInputScreen({Key? key}) : super(key: key);

  @override
  State<CarbonInputScreen> createState() => _CarbonInputScreenState();
}

class _CarbonInputScreenState extends State<CarbonInputScreen> {
  // ✅ Default values (Error-prevention)
  String fertilizerUsage = 'Medium';
  String tillageMethod = 'Minimum Till';
  String irrigationType = 'Rain-fed';

  void _onSubmit(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white),
            SizedBox(width: 12),
            Text(
              'Farm activity saved',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
        backgroundColor: Colors.green.shade700,
        behavior: SnackBarBehavior.floating,
      ),
    );

    Future.delayed(const Duration(milliseconds: 600), () {
      Navigator.pushReplacementNamed(context, AppRoutes.carbonDashboard);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.green.shade700,
        centerTitle: true,
        title: const Text(
          'Add Farm Activity',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Tell us about your farming',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Colors.green.shade800,
                      fontWeight: FontWeight.bold,
                    ),
              ),

              const SizedBox(height: 24),

              /// 🌳 Trees planted
              const CarbonTextField(
                label: 'Trees Planted',
                hint: 'Most farmers enter 5–20 trees',
                icon: Icons.park,
                keyboardType: TextInputType.number,
              ),

              const SizedBox(height: 20),

              /// 🧪 Fertilizer usage (default = Medium)
              CarbonDropdownField(
                label: 'Fertilizer Usage',
                hint: 'Most farmers choose Medium',
                icon: Icons.science,
                value: fertilizerUsage,
                items: const ['Low', 'Medium', 'High'],
                onChanged: (val) => setState(() => fertilizerUsage = val),
              ),

              const SizedBox(height: 20),

              /// 🚜 Tillage method
              CarbonDropdownField(
                label: 'Tillage Method',
                hint: 'Minimum till is common',
                icon: Icons.agriculture,
                value: tillageMethod,
                items: const ['No Till', 'Minimum Till', 'Traditional'],
                onChanged: (val) => setState(() => tillageMethod = val),
              ),

              const SizedBox(height: 20),

              /// 💧 Irrigation type
              CarbonDropdownField(
                label: 'Irrigation Type',
                hint: 'Rain-fed is common',
                icon: Icons.water,
                value: irrigationType,
                items: const ['Rain-fed', 'Drip', 'Flood'],
                onChanged: (val) => setState(() => irrigationType = val),
              ),

              const SizedBox(height: 40),

              /// ✅ Save button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton.icon(
                  onPressed: () => _onSubmit(context),
                  icon: const Icon(Icons.check, size: 28),
                  label: const Text(
                    'Save Activity',
                    style: TextStyle(fontSize: 18),
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

      bottomNavigationBar: const AgriBottomNav(currentIndex: 2),
    );
  }
}

/// ---------- Reusable Inputs ----------

class CarbonTextField extends StatelessWidget {
  final String label;
  final String hint;
  final IconData icon;
  final TextInputType keyboardType;

  const CarbonTextField({
    super.key,
    required this.label,
    required this.hint,
    required this.icon,
    required this.keyboardType,
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
        TextField(
          keyboardType: keyboardType,
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

class CarbonDropdownField extends StatelessWidget {
  final String label;
  final String hint;
  final IconData icon;
  final List<String> items;
  final String value;
  final ValueChanged<String> onChanged;

  const CarbonDropdownField({
    super.key,
    required this.label,
    required this.hint,
    required this.icon,
    required this.items,
    required this.value,
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
