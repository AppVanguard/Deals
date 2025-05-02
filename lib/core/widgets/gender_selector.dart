import 'package:flutter/material.dart';

enum Gender { male, female, other }

class GenderSelector extends StatefulWidget {
  final String? initialGender; // ← NEW
  final ValueChanged<String> onGenderSelected;
  final String label;
  final String? Function(Gender?)? validator;

  const GenderSelector({
    super.key,
    this.initialGender, // ← NEW
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

  @override
  void initState() {
    super.initState();
    // PREFILL the radio from the passed initialGender string
    switch (widget.initialGender) {
      case 'male':
        _selectedGender = Gender.male;
        break;
      case 'female':
        _selectedGender = Gender.female;
        break;
      case 'other':
        _selectedGender = Gender.other;
        break;
      default:
        _selectedGender = null;
    }
    _errorText = widget.validator?.call(_selectedGender);
  }

  void _handleGenderChange(Gender? gender) {
    setState(() {
      _selectedGender = gender;
      _errorText = widget.validator?.call(_selectedGender);
    });
    if (gender != null) {
      final genderStr = gender.name; // "male", "female", or "other"
      widget.onGenderSelected(genderStr);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.label,
              style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          Row(
            children: [
              _buildRadio(Gender.male, "Male"),
              _buildRadio(Gender.female, "Female"),
              _buildRadio(Gender.other, "Other"),
            ],
          ),
          if (_errorText != null)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(_errorText!,
                  style: const TextStyle(color: Colors.red, fontSize: 12)),
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
          activeColor: Colors.green,
        ),
        Text(label, style: const TextStyle(fontSize: 16)),
      ],
    );
  }
}
