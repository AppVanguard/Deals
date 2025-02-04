import 'package:flutter/material.dart';
import 'package:country_picker/country_picker.dart';
import 'package:in_pocket/core/utils/app_colors.dart';
import 'package:in_pocket/core/utils/app_text_styles.dart';
import 'package:in_pocket/generated/l10n.dart';

class CountrySelectorField extends StatefulWidget {
  final ValueChanged<Country> onCountrySelected;
  final String label;
  final String? Function(Country?)? validator;

  const CountrySelectorField({
    super.key,
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

  void _openCountryPicker() {
    showCountryPicker(
      context: context,
      showPhoneCode: false,
      onSelect: (Country country) {
        setState(() {
          _selectedCountry = country;
          _errorText = widget.validator?.call(_selectedCountry);
        });
        widget.onCountrySelected(country);
      },
      countryListTheme: CountryListThemeData(
        flagSize: 25,
        backgroundColor: Colors.white,
        textStyle: const TextStyle(fontSize: 16, color: Colors.black87),
        bottomSheetHeight: 500,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
        inputDecoration: InputDecoration(
          labelText: S.of(context).Search,
          hintText: S.of(context).SearchHint,
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.label,
            style: AppTextStyles.regular14.copyWith(color: AppColors.text),
          ),
          GestureDetector(
            onTap: _openCountryPicker,
            child: InputDecorator(
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                suffixIcon: const Icon(Icons.arrow_drop_down),
                errorText: _errorText, // Display validation error
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
