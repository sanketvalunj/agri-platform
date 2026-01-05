import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class AddCropBottomSheet extends StatefulWidget {
  const AddCropBottomSheet({Key? key}) : super(key: key);

  @override
  State<AddCropBottomSheet> createState() => _AddCropBottomSheetState();
}

class _AddCropBottomSheetState extends State<AddCropBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final _cropNameController = TextEditingController();
  final _areaController = TextEditingController();
  String? _selectedCropType;
  DateTime? _plantedDate;

  final List<String> _cropTypes = [
    'Wheat',
    'Rice',
    'Cotton',
    'Sugarcane',
    'Maize',
    'Soybean',
    'Vegetables',
    'Fruits',
    'Other'
  ];

  @override
  void dispose() {
    _cropNameController.dispose();
    _areaController.dispose();
    super.dispose();
  }

  void _selectPlantedDate() async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(Duration(days: 365)),
      lastDate: DateTime.now(),
    );

    if (selectedDate != null) {
      setState(() => _plantedDate = selectedDate);
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate() && _plantedDate != null) {
      HapticFeedback.mediumImpact();
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text('Crop "${_cropNameController.text}" added successfully'),
          backgroundColor: Theme.of(context).colorScheme.primary,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: 85.h,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 1.h),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(4.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Add New Crop',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: CustomIconWidget(
                    iconName: 'close',
                    color: theme.colorScheme.onSurface,
                    size: 24,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          Divider(height: 1),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(4.w),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Crop Name',
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 1.h),
                    TextFormField(
                      controller: _cropNameController,
                      decoration: InputDecoration(
                        hintText: 'e.g., Wheat Field A',
                        prefixIcon: CustomIconWidget(
                          iconName: 'agriculture',
                          color: theme.colorScheme.primary,
                          size: 20,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter crop name';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      'Crop Type',
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 1.h),
                    DropdownButtonFormField<String>(
                      initialValue: _selectedCropType,
                      decoration: InputDecoration(
                        hintText: 'Select crop type',
                        prefixIcon: CustomIconWidget(
                          iconName: 'category',
                          color: theme.colorScheme.primary,
                          size: 20,
                        ),
                      ),
                      items: _cropTypes.map((type) {
                        return DropdownMenuItem(
                          value: type,
                          child: Text(type),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() => _selectedCropType = value);
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Please select crop type';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      'Area (acres)',
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 1.h),
                    TextFormField(
                      controller: _areaController,
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: true),
                      decoration: InputDecoration(
                        hintText: 'e.g., 2.5',
                        prefixIcon: CustomIconWidget(
                          iconName: 'square_foot',
                          color: theme.colorScheme.primary,
                          size: 20,
                        ),
                        suffixText: 'acres',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter area';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Please enter valid number';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      'Planted Date',
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 1.h),
                    InkWell(
                      onTap: _selectPlantedDate,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 4.w,
                          vertical: 2.h,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: theme.colorScheme.outline,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            CustomIconWidget(
                              iconName: 'calendar_today',
                              color: theme.colorScheme.primary,
                              size: 20,
                            ),
                            SizedBox(width: 3.w),
                            Text(
                              _plantedDate != null
                                  ? '${_plantedDate!.day}/${_plantedDate!.month}/${_plantedDate!.year}'
                                  : 'Select planted date',
                              style: theme.textTheme.bodyLarge?.copyWith(
                                color: _plantedDate != null
                                    ? theme.colorScheme.onSurface
                                    : theme.colorScheme.onSurface
                                        .withValues(alpha: 0.6),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (_plantedDate == null)
                      Padding(
                        padding: EdgeInsets.only(top: 0.5.h, left: 4.w),
                        child: Text(
                          'Please select planted date',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.error,
                          ),
                        ),
                      ),
                    SizedBox(height: 3.h),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _submitForm,
                        icon: CustomIconWidget(
                          iconName: 'add',
                          color: theme.colorScheme.onPrimary,
                          size: 20,
                        ),
                        label: Text('Add Crop'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.colorScheme.primary,
                          foregroundColor: theme.colorScheme.onPrimary,
                          padding: EdgeInsets.symmetric(vertical: 2.h),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
