import 'package:country_picker/country_picker.dart';
import 'package:deals/core/utils/app_colors.dart';
import 'package:deals/core/utils/app_text_styles.dart';
import 'package:deals/generated/l10n.dart';
import 'package:flutter/material.dart';

/// Dropdown-like field allowing the user to pick a country.
///
/// Uses the [country_picker] package and provides validation along with an
/// optional pre-selected [initialCountry]. The selected value is returned via
/// [onCountrySelected].

class CountrySelectorField extends StatefulWidget {
  /// Initially selected country.
  final Country? initialCountry; // ← NEW

  /// Called when the user selects a country.
  final ValueChanged<Country> onCountrySelected;

  /// Label displayed above the field.
  final String label;

  /// Optional validation callback for the chosen country.
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
    return Column(
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
    );
  }
}
