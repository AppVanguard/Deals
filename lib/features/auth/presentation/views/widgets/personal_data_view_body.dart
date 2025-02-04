import 'package:flutter/material.dart';
import 'package:country_picker/country_picker.dart';
import 'package:in_pocket/core/utils/app_colors.dart';
import 'package:in_pocket/core/widgets/country_selector_field.dart';
import 'package:in_pocket/core/widgets/custom_button.dart';
import 'package:in_pocket/core/widgets/custom_text_form_field.dart';
import 'package:in_pocket/core/widgets/date_picker_field.dart';
import 'package:in_pocket/core/widgets/gender_selector.dart';
import 'package:in_pocket/features/auth/presentation/views/signin_view.dart';
import 'package:in_pocket/generated/l10n.dart';

class PersonalDataViewBody extends StatefulWidget {
  const PersonalDataViewBody({super.key});

  @override
  State<PersonalDataViewBody> createState() => _PersonalDataViewBodyState();
}

class _PersonalDataViewBodyState extends State<PersonalDataViewBody> {
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;
  late GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late Country selectedCountry;
  late String city;
  late DateTime birthday;
  late Gender selectedGender;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: formKey,
        autovalidateMode: autovalidateMode,
        child: Column(
          spacing: 20,
          children: [
            CountrySelectorField(
              validator: (value) {
                if (value == null) {
                  return S.of(context).CountryValidator;
                }
                return null;
              },
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
                onSaved: (value) {
                  city = value!;
                },
                hintText: S.of(context).City,
                textInputType: TextInputType.text,
                label: S.of(context).City,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return S.of(context).CityValidator;
                  }
                  return null;
                }),
            CustomDatePicker(
              validator: (value) {
                if (value == null) {
                  return S.of(context).BirthdayValidator;
                }
                return null;
              },
              onDateSelected: (value) {
                birthday = value;
              },
            ),
            GenderSelector(
                onGenderSelected: (value) {
                  selectedGender = value;
                },
                label: S.of(context).Gender),
            CustomButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  formKey.currentState!.save();
                  Navigator.popUntil(
                    context,
                    (route) => route.settings.name == SigninView.routeName,
                  );
                }
              },
              width: double.infinity,
              text: S.of(context).Save,
            ),
            CustomButton(
              onPressed: () {
                Navigator.popUntil(
                  context,
                  (route) => route.settings.name == SigninView.routeName,
                );
              },
              width: double.infinity,
              text: S.of(context).Later,
              textColor: AppColors.text,
              buttonColor: AppColors.lightGray,
            )
          ],
        ),
      ),
    );
  }
}
