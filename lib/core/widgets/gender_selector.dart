import 'package:flutter/material.dart';

enum Gender { male, female, other }

class GenderSelector extends StatefulWidget {
  final ValueChanged<Gender> onGenderSelected;
  final String label;
  final String? Function(Gender?)? validator;

  const GenderSelector({
    super.key,
    required this.onGenderSelected,
    required this.label,
    this.validator,
  });

  @override
  State<GenderSelector> createState() => _GenderSelectorState();
}

class _GenderSelectorState extends State<GenderSelector> {
  Gender? _selectedGender;
  String? _errorText;

  void _handleGenderChange(Gender? gender) {
    setState(() {
      _selectedGender = gender;
      _errorText = widget.validator?.call(_selectedGender);
    });
    widget.onGenderSelected(gender!);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.label,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _buildRadio(Gender.male, "Male"),
              _buildRadio(Gender.female, "Female"),
              _buildRadio(Gender.other, "Other"),
            ],
          ),
          if (_errorText != null) // Show error message if validation fails
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                _errorText!,
                style: const TextStyle(color: Colors.red, fontSize: 12),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildRadio(Gender gender, String label) {
    return Row(
      children: [
        Radio<Gender>(
          value: gender,
          groupValue: _selectedGender,
          onChanged: _handleGenderChange,
          activeColor: Colors.green, // Green selection color
        ),
        Text(label, style: const TextStyle(fontSize: 16)),
      ],
    );
  }
}
