import 'package:flutter/material.dart';
import 'package:country_picker/country_picker.dart';
import 'package:in_pocket/core/widgets/country_selector_field.dart';
import 'package:in_pocket/core/widgets/custom_text_form_field.dart';
import 'package:in_pocket/core/widgets/date_picker_field.dart';
import 'package:in_pocket/generated/l10n.dart';

class PersonalDataViewBody extends StatefulWidget {
  const PersonalDataViewBody({super.key});

  @override
  State<PersonalDataViewBody> createState() => _PersonalDataViewBodyState();
}

class _PersonalDataViewBodyState extends State<PersonalDataViewBody> {
  late Country selectedCountry;
  late String city;
  late DateTime birthday;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        spacing: 20,
        children: [
          CountrySelectorField(
            label: S.of(context).Country,
            onCountrySelected: (Country country) {
              setState(
                () {
                  selectedCountry = country;
                },
              );
            },
          ),
          CustomTextFormField(
              hintText: S.of(context).City,
              textInputType: TextInputType.text,
              label: S.of(context).City,
              validator: (value) {}),
          CustomDatePicker(
            onDateSelected: (value) {},
          ),
        ],
      ),
    );
  }
}
