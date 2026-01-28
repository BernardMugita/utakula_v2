// features/account/presentation/widgets/edit_metrics_dialog.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:utakula_v2/common/themes/theme_utils.dart';

class EditMetricsDialog extends StatefulWidget {
  final Map<String, dynamic>? currentMetrics;

  const EditMetricsDialog({super.key, this.currentMetrics});

  @override
  State<EditMetricsDialog> createState() => _EditMetricsDialogState();
}

class _EditMetricsDialogState extends State<EditMetricsDialog> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController weightController;
  late TextEditingController heightController;
  late TextEditingController ageController;
  late TextEditingController bodyFatController;

  String selectedGender = 'male';
  String selectedActivityLevel = 'moderately_active';

  double calculatedTDEE = 0;

  @override
  void initState() {
    super.initState();

    // Initialize with current metrics or defaults
    weightController = TextEditingController(
      text: widget.currentMetrics?['weight_kg']?.toString() ?? '75',
    );
    heightController = TextEditingController(
      text: widget.currentMetrics?['height_cm']?.toString() ?? '175',
    );
    ageController = TextEditingController(
      text: widget.currentMetrics?['age']?.toString() ?? '28',
    );
    bodyFatController = TextEditingController(
      text: widget.currentMetrics?['body_fat_percentage']?.toString() ?? '18',
    );

    selectedGender = widget.currentMetrics?['gender'] ?? 'male';
    selectedActivityLevel =
        widget.currentMetrics?['activity_level'] ?? 'moderately_active';

    _calculateTDEE();
  }

  void _calculateTDEE() {
    final weight = double.tryParse(weightController.text) ?? 75.0;
    final bodyFat = double.tryParse(bodyFatController.text) ?? 18.0;

    // Katch-McArdle Formula
    final leanBodyMass = weight * (1 - bodyFat / 100);
    final bmr = 370 + (21.6 * leanBodyMass);

    final activityMultipliers = {
      'sedentary': 1.2,
      'lightly_active': 1.375,
      'moderately_active': 1.55,
      'very_active': 1.725,
      'extra_active': 1.9,
    };

    final multiplier = activityMultipliers[selectedActivityLevel] ?? 1.55;
    setState(() {
      calculatedTDEE = bmr * multiplier;
    });
  }

  void _handleSave() {
    if (_formKey.currentState!.validate()) {
      final metrics = {
        'gender': selectedGender,
        'age': int.parse(ageController.text),
        'weight_kg': double.parse(weightController.text),
        'height_cm': double.parse(heightController.text),
        'body_fat_percentage': double.parse(bodyFatController.text),
        'activity_level': selectedActivityLevel,
        'calculated_tdee': calculatedTDEE,
        'updated_at': DateTime.now().toIso8601String(),
      };

      Navigator.pop(context, metrics);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(20),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 500),
        decoration: BoxDecoration(
          color: ThemeUtils.backgroundColor(context),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    ThemeUtils.primaryColor(context),
                    ThemeUtils.primaryColor(context).withOpacity(0.8),
                  ],
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      FluentIcons.heart_pulse_24_filled,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const Gap(12),
                  const Expanded(
                    child: Text(
                      'Edit Health Metrics',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(
                      FluentIcons.dismiss_24_regular,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),

            // Form Content
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // TDEE Preview
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.deepPurple.shade400,
                              Colors.deepPurple.shade600,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          children: [
                            const Text(
                              'Calculated TDEE',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const Gap(8),
                            Text(
                              '${calculatedTDEE.toStringAsFixed(0)} cal/day',
                              style: const TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Gap(24),

                      // Gender Selection
                      Text(
                        'Gender',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: ThemeUtils.primaryColor(context),
                        ),
                      ),
                      const Gap(8),
                      Row(
                        children: [
                          Expanded(
                            child: _buildGenderOption(
                              'male',
                              'Male',
                              FluentIcons.person_24_filled,
                            ),
                          ),
                          const Gap(12),
                          Expanded(
                            child: _buildGenderOption(
                              'female',
                              'Female',
                              FluentIcons.person_24_regular,
                            ),
                          ),
                        ],
                      ),
                      const Gap(20),

                      // Physical Metrics Grid
                      Row(
                        children: [
                          Expanded(
                            child: _buildTextField(
                              controller: ageController,
                              label: 'Age',
                              suffix: 'years',
                              icon: FluentIcons.calendar_24_regular,
                              iconColor: Colors.orange,
                              onChanged: (v) => _calculateTDEE(),
                            ),
                          ),
                          const Gap(12),
                          Expanded(
                            child: _buildTextField(
                              controller: weightController,
                              label: 'Weight',
                              suffix: 'kg',
                              icon: FluentIcons.scale_fill_20_regular,
                              iconColor: Colors.blue,
                              onChanged: (v) => _calculateTDEE(),
                            ),
                          ),
                        ],
                      ),
                      const Gap(12),
                      Row(
                        children: [
                          Expanded(
                            child: _buildTextField(
                              controller: heightController,
                              label: 'Height',
                              suffix: 'cm',
                              icon: FluentIcons.ruler_24_regular,
                              iconColor: Colors.purple,
                              onChanged: (v) => _calculateTDEE(),
                            ),
                          ),
                          const Gap(12),
                          Expanded(
                            child: _buildTextField(
                              controller: bodyFatController,
                              label: 'Body Fat',
                              suffix: '%',
                              icon: FluentIcons.heart_pulse_24_regular,
                              iconColor: Colors.red,
                              onChanged: (v) => _calculateTDEE(),
                            ),
                          ),
                        ],
                      ),
                      const Gap(20),

                      // Activity Level
                      Text(
                        'Activity Level',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: ThemeUtils.primaryColor(context),
                        ),
                      ),
                      const Gap(8),
                      _buildActivityLevelSelector(),
                      const Gap(24),

                      // Save Button
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          onPressed: _handleSave,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ThemeUtils.primaryColor(context),
                            foregroundColor: ThemeUtils.secondaryColor(context),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 0,
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(FluentIcons.save_24_regular, size: 20),
                              Gap(10),
                              Text(
                                'Save Metrics',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
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
      ),
    );
  }

  Widget _buildGenderOption(String value, String label, IconData icon) {
    final isSelected = selectedGender == value;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedGender = value;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? ThemeUtils.primaryColor(context).withOpacity(0.1)
              : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? ThemeUtils.primaryColor(context)
                : Colors.transparent,
            width: 2,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected
                  ? ThemeUtils.primaryColor(context)
                  : Colors.grey.shade600,
              size: 20,
            ),
            const Gap(8),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isSelected
                    ? ThemeUtils.primaryColor(context)
                    : Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String suffix,
    required IconData icon,
    required Color iconColor,
    required Function(String) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: iconColor),
            const Gap(6),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade700,
              ),
            ),
          ],
        ),
        const Gap(8),
        TextFormField(
          controller: controller,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,1}')),
          ],
          onChanged: onChanged,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Required';
            }
            return null;
          },
          decoration: InputDecoration(
            suffixText: suffix,
            filled: true,
            fillColor: ThemeUtils.blacks(context).withOpacity(0.1),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: ThemeUtils.secondaryColor(context),
                width: 1,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActivityLevelSelector() {
    final levels = [
      {
        'value': 'sedentary',
        'label': '😴 Sedentary',
        'desc': 'Little to no exercise',
      },
      {
        'value': 'lightly_active',
        'label': '🚶 Lightly Active',
        'desc': 'Exercise 1-3 days/week',
      },
      {
        'value': 'moderately_active',
        'label': '🏃 Moderately Active',
        'desc': 'Exercise 3-5 days/week',
      },
      {
        'value': 'very_active',
        'label': '💪 Very Active',
        'desc': 'Exercise 6-7 days/week',
      },
      {
        'value': 'extra_active',
        'label': '🔥 Extra Active',
        'desc': 'Very hard exercise & physical job',
      },
    ];

    return Column(
      children: levels.map((level) {
        final isSelected = selectedActivityLevel == level['value'];
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: GestureDetector(
            onTap: () {
              setState(() {
                selectedActivityLevel = level['value']!;
              });
              _calculateTDEE();
            },
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: isSelected
                    ? ThemeUtils.primaryColor(context).withOpacity(0.7)
                    : ThemeUtils.secondaryColor(context),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected
                      ? Colors.green.shade600
                      : Colors.transparent,
                  width: 2,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected
                            ? Colors.green.shade600
                            : Colors.grey.shade400,
                        width: 2,
                      ),
                      color: isSelected
                          ? Colors.green.shade600
                          : Colors.transparent,
                    ),
                    child: isSelected
                        ? const Icon(Icons.check, size: 14, color: Colors.white)
                        : null,
                  ),
                  const Gap(12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          level['label']!,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: isSelected
                                ? ThemeUtils.blacks(context)
                                : ThemeUtils.primaryColor(context),
                          ),
                        ),
                        Text(
                          level['desc']!,
                          style: TextStyle(
                            fontSize: 11,
                            color: ThemeUtils.blacks(context),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  @override
  void dispose() {
    weightController.dispose();
    heightController.dispose();
    ageController.dispose();
    bodyFatController.dispose();
    super.dispose();
  }
}
