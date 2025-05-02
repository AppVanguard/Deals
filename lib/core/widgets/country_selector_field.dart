import 'package:country_picker/country_picker.dart';
import 'package:deals/core/utils/app_colors.dart';
import 'package:deals/core/utils/app_text_styles.dart';
import 'package:deals/generated/l10n.dart';
import 'package:flutter/material.dart';

class CountrySelectorField extends StatefulWidget {
  final Country? initialCountry; // ← NEW
  final ValueChanged<Country> onCountrySelected;
  final String label;
  final String? Function(Country?)? validator;

  const CountrySelectorField({
    super.key,
    this.initialCountry, // ← NEW
    required this.onCountrySelected,
    required this.label,
    this.validator,
  });

  @override
  State<CountrySelectorField> createState() => _CountrySelectorFieldState();
}

class _CountrySelectorFieldState extends State<CountrySelectorField> {
  Country? _selectedCountry;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _selectedCountry = widget.initialCountry; // PREFILL
    _errorText = widget.validator?.call(_selectedCountry);
  }

  void _openCountryPicker() {
    showCountryPicker(
      context: context,
      onSelect: (Country country) {
        setState(() {
          _selectedCountry = country;
          _errorText = widget.validator?.call(_selectedCountry);
        });
        widget.onCountrySelected(country);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.label,
              style: AppTextStyles.regular14.copyWith(color: AppColors.text)),
          const SizedBox(height: 4),
          GestureDetector(
            onTap: _openCountryPicker,
            child: InputDecorator(
              decoration: InputDecoration(
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                suffixIcon: const Icon(Icons.arrow_drop_down),
                errorText: _errorText,
              ),
              child: Row(
                children: [
                  if (_selectedCountry != null)
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Text(_selectedCountry!.flagEmoji),
                    ),
                  Expanded(
                    child: Text(
                      _selectedCountry?.name ?? S.of(context).SelectCountry,
                      style: const TextStyle(fontSize: 17),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
