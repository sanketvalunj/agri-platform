import 'package:flutter/material.dart';
import '../../../models/user_profile.dart';
import '../../../services/profile_service.dart';
import '../../../services/farm_info_service.dart';
import '../../../shared/widgets/agri_bottom_nav.dart';

class FarmProfileEditScreen extends StatefulWidget {
  const FarmProfileEditScreen({Key? key}) : super(key: key);

  @override
  State<FarmProfileEditScreen> createState() => _FarmProfileEditScreenState();
}

class _FarmProfileEditScreenState extends State<FarmProfileEditScreen> {
  final _formKey = GlobalKey<FormState>();

  // Form controllers
  final _farmAreaController = TextEditingController();
  final _farmingExperienceController = TextEditingController();
  final _bioController = TextEditingController();

  // Dropdown selections
  String _selectedFarmAreaUnit = 'Acres';
  String _selectedFarmingType = '';
  String _selectedIrrigation = '';
  String _selectedSoilType = '';
  List<String> _selectedCrops = [];

  bool _isLoading = false;
  UserProfile? _currentProfile;

  @override
  void initState() {
    super.initState();
    _loadCurrentProfile();
  }

  @override
  void dispose() {
    _farmAreaController.dispose();
    _farmingExperienceController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  Future<void> _loadCurrentProfile() async {
    setState(() => _isLoading = true);
    try {
      final profile = await ProfileService.getUserProfile();

      setState(() {
        _currentProfile = profile;
        _farmAreaController.text = profile.farmArea.toString();
        _farmingExperienceController.text =
            profile.farmingExperience.toString();
        _bioController.text = profile.bio;
        _selectedFarmAreaUnit = profile.farmAreaUnit;
        _selectedFarmingType = profile.farmingType;
        _selectedIrrigation = profile.irrigation;
        _selectedSoilType = profile.soilType;
        _selectedCrops = List.from(profile.cropTypes);
      });
    } catch (e) {
      debugPrint('Error loading profile: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      final farmArea = double.parse(_farmAreaController.text.trim());
      final farmingExperience =
          int.parse(_farmingExperienceController.text.trim());

      // Validate farm information
      final errors = FarmInfoService.validateFarmInfo(
        farmArea: farmArea,
        farmAreaUnit: _selectedFarmAreaUnit,
        cropTypes: _selectedCrops,
        farmingType: _selectedFarmingType,
        irrigation: _selectedIrrigation,
        soilType: _selectedSoilType,
        farmingExperience: farmingExperience,
      );

      if (errors.isNotEmpty) {
        _showValidationErrors(errors);
        return;
      }

      // Calculate trust score
      final updatedProfile = _currentProfile?.copyWith(
            farmArea: farmArea,
            farmAreaUnit: _selectedFarmAreaUnit,
            cropTypes: _selectedCrops,
            farmingType: _selectedFarmingType,
            irrigation: _selectedIrrigation,
            soilType: _selectedSoilType,
            farmingExperience: farmingExperience,
            bio: _bioController.text.trim(),
            lastCarbonUpdate: DateTime.now(),
          ) ??
          UserProfile.empty();

      // Calculate trust score
      final trustScore = FarmInfoService.calculateTrustScore(updatedProfile);
      final profileWithTrustScore =
          updatedProfile.copyWith(trustScore: trustScore);

      await ProfileService.saveUserProfile(profileWithTrustScore);
      await FarmInfoService.saveFarmInfo(profileWithTrustScore);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Farm profile saved successfully!'),
            backgroundColor: Color(0xFF2E7D32),
            duration: Duration(seconds: 2),
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      debugPrint('Error saving profile: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error saving profile. Please try again.'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showValidationErrors(Map<String, String> errors) {
    final errorMessage = errors.values.join('\n');
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Validation Errors'),
        content: Text(errorMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showCropSelectionDialog() {
    final availableCrops = FarmInfoService.getAvailableCrops();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Crops'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: availableCrops.length,
            itemBuilder: (context, index) {
              final crop = availableCrops[index];
              final isSelected = _selectedCrops.contains(crop);

              return CheckboxListTile(
                title: Text(crop),
                value: isSelected,
                onChanged: (value) {
                  setState(() {
                    if (value == true) {
                      _selectedCrops.add(crop);
                    } else {
                      _selectedCrops.remove(crop);
                    }
                  });
                  Navigator.pop(context);
                  _showCropSelectionDialog(); // Reopen to show updated selection
                },
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAF9),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text(
          'Edit Farm Profile',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            )
          else
            TextButton(
              onPressed: _saveProfile,
              child: const Text(
                'Save',
                style: TextStyle(
                  color: Color(0xFF2E7D32),
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildFarmAreaSection(),
                    const SizedBox(height: 20),
                    _buildCropSelectionSection(),
                    const SizedBox(height: 20),
                    _buildFarmingDetailsSection(),
                    const SizedBox(height: 20),
                    _buildBioSection(),
                    const SizedBox(height: 40),
                    _buildSaveButton(),
                    const SizedBox(height: 100), // Extra padding for bottom nav
                  ],
                ),
              ),
            ),
      bottomNavigationBar: const AgriBottomNav(currentIndex: 3),
    );
  }

  Widget _buildFarmAreaSection() {
    return _buildSectionCard(
      title: '🌾 Farm Area',
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: 2,
                child: TextFormField(
                  controller: _farmAreaController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Farm Area',
                    hintText: 'Enter farm area',
                    prefixIcon: Icon(Icons.landscape, color: Color(0xFF2E7D32)),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Farm area is required';
                    }
                    final area = double.tryParse(value.trim());
                    if (area == null || area <= 0) {
                      return 'Please enter a valid area';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: _selectedFarmAreaUnit,
                  decoration: const InputDecoration(
                    labelText: 'Unit',
                    border: OutlineInputBorder(),
                  ),
                  items: FarmInfoService.getFarmAreaUnits()
                      .map((unit) =>
                          DropdownMenuItem(value: unit, child: Text(unit)))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedFarmAreaUnit = value!;
                    });
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCropSelectionSection() {
    return _buildSectionCard(
      title: '🌱 Crop Selection',
      subtitle: 'Select crops you grow on your farm',
      child: Column(
        children: [
          GestureDetector(
            onTap: _showCropSelectionDialog,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.agriculture, color: const Color(0xFF2E7D32)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      _selectedCrops.isNotEmpty
                          ? '${_selectedCrops.length} crops selected'
                          : 'Select crops',
                      style: TextStyle(
                        color: _selectedCrops.isNotEmpty
                            ? Colors.black87
                            : Colors.grey.shade600,
                      ),
                    ),
                  ),
                  Icon(Icons.arrow_drop_down, color: Colors.grey.shade600),
                ],
              ),
            ),
          ),
          if (_selectedCrops.isNotEmpty) ...[
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _selectedCrops.map((crop) {
                return Chip(
                  label: Text(crop),
                  deleteIcon: const Icon(Icons.close, size: 18),
                  onDeleted: () {
                    setState(() {
                      _selectedCrops.remove(crop);
                    });
                  },
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildFarmingDetailsSection() {
    return _buildSectionCard(
      title: '🚜 Farming Details',
      child: Column(
        children: [
          DropdownButtonFormField<String>(
            value:
                _selectedFarmingType.isNotEmpty ? _selectedFarmingType : null,
            decoration: const InputDecoration(
              labelText: 'Farming Type',
              hintText: 'Select farming type',
              prefixIcon: Icon(Icons.nature, color: Color(0xFF2E7D32)),
              border: OutlineInputBorder(),
            ),
            items: FarmInfoService.getFarmingTypes()
                .map((type) => DropdownMenuItem(value: type, child: Text(type)))
                .toList(),
            onChanged: (value) {
              setState(() {
                _selectedFarmingType = value!;
              });
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please select farming type';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            value: _selectedIrrigation.isNotEmpty ? _selectedIrrigation : null,
            decoration: const InputDecoration(
              labelText: 'Irrigation Type',
              hintText: 'Select irrigation type',
              prefixIcon: Icon(Icons.water_drop, color: Color(0xFF2E7D32)),
              border: OutlineInputBorder(),
            ),
            items: FarmInfoService.getIrrigationTypes()
                .map((type) => DropdownMenuItem(value: type, child: Text(type)))
                .toList(),
            onChanged: (value) {
              setState(() {
                _selectedIrrigation = value!;
              });
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please select irrigation type';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            value: _selectedSoilType.isNotEmpty ? _selectedSoilType : null,
            decoration: const InputDecoration(
              labelText: 'Soil Type',
              hintText: 'Select soil type',
              prefixIcon: Icon(Icons.terrain, color: Color(0xFF2E7D32)),
              border: OutlineInputBorder(),
            ),
            items: FarmInfoService.getSoilTypes()
                .map((type) => DropdownMenuItem(value: type, child: Text(type)))
                .toList(),
            onChanged: (value) {
              setState(() {
                _selectedSoilType = value!;
              });
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please select soil type';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _farmingExperienceController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Farming Experience (years)',
              hintText: 'Enter years of farming experience',
              prefixIcon: Icon(Icons.work, color: Color(0xFF2E7D32)),
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Farming experience is required';
              }
              final experience = int.tryParse(value.trim());
              if (experience == null || experience < 0) {
                return 'Please enter valid experience';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBioSection() {
    return _buildSectionCard(
      title: '📝 Additional Information',
      subtitle: 'Tell us more about your farm (optional)',
      child: TextFormField(
        controller: _bioController,
        maxLines: 4,
        maxLength: 200,
        decoration: const InputDecoration(
          labelText: 'Farm Description',
          hintText: 'Describe your farm, special practices, goals...',
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    String? subtitle,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 4),
            Text(
              subtitle!,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),
          ],
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _saveProfile,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF2E7D32),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child: _isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : const Text(
                'Save Farm Profile',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }
}
