import 'package:deals/features/auth/presentation/views/widgets/custom_phone_field.dart';
import 'package:deals/features/personal_data/presentation/manager/personal_data_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:country_picker/country_picker.dart';

import 'package:deals/generated/l10n.dart';
import 'package:deals/core/entities/user_entity.dart';
import 'package:deals/core/widgets/custom_text_form_field.dart';
import 'package:deals/core/widgets/country_selector_field.dart';
import 'package:deals/core/widgets/custom_date_picker.dart';
import 'package:deals/core/widgets/gender_selector.dart';
import 'package:deals/core/widgets/custom_button.dart';

class PersonalDataViewBody extends StatefulWidget {
  const PersonalDataViewBody({super.key, required this.user});

  final UserEntity user;

  @override
  State<PersonalDataViewBody> createState() => _PersonalDataViewBodyState();
}

class _PersonalDataViewBodyState extends State<PersonalDataViewBody> {
  final _formKey = GlobalKey<FormState>();
  AutovalidateMode _autoValidate = AutovalidateMode.disabled;

  // local form values
  late String _fullName;
  late String _phone;
  Country? _country;
  String? _city;
  DateTime? _birthDate;
  String? _gender;

  @override
  void initState() {
    super.initState();
    _fullName = widget.user.fullName;
    _phone = widget.user.phone;
    _city = widget.user.city;
    if (widget.user.country != null) {
      _country = Country.parse(widget.user.country!);
    }
    _birthDate = widget.user.dateOfBirth;
    _gender = widget.user.gender;
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<PersonalDataCubit>();

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Form(
        key: _formKey,
        autovalidateMode: _autoValidate,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Email (read-only)
            CustomTextFormField(
              label: S.of(context).Email,
              hintText: widget.user.email,
              textInputType: TextInputType.emailAddress,
              validator: (_) => null,
              enabled: false,
            ),

            const SizedBox(height: 16),

            // Full name
            CustomTextFormField(
              label: S.of(context).FullName,
              hintText: S.of(context).FullName,
              initialValue: _fullName,
              textInputType: TextInputType.name,
              validator: (v) => v == null || v.isEmpty
                  ? S.of(context).FullNameValidator
                  : null,
              onSaved: (v) => _fullName = v!.trim(),
            ),

            const SizedBox(height: 16),

            // Phone
            CustomPhoneField(
              label: S.of(context).Phone,
              initialCountryCode: _country?.countryCode ?? 'EG',
              initialValue: _phone,
              validator: (pn) =>
                  pn == null ? S.of(context).PhoneValidator : null,
              onChanged: (pn) => _phone = pn.completeNumber,
              onSaved: (pn) => _phone = pn?.completeNumber ?? '',
            ),

            const SizedBox(height: 16),

            // Country
            CountrySelectorField(
              label: S.of(context).Country,
              initialCountry: _country,
              validator: (c) =>
                  c == null ? S.of(context).CountryValidator : null,
              onCountrySelected: (c) => _country = c,
            ),

            const SizedBox(height: 16),

            // City / Town
            CustomTextFormField(
              label: S.of(context).City,
              hintText: S.of(context).CityHint,
              initialValue: _city,
              textInputType: TextInputType.text,
              validator: (v) =>
                  v == null || v.isEmpty ? S.of(context).CityValidator : null,
              onSaved: (v) => _city = v!.trim(),
            ),

            const SizedBox(height: 16),

            // Birth date
            CustomDatePicker(
              initialDate: _birthDate,
              validator: (d) =>
                  d == null ? S.of(context).BirthdayValidator : null,
              onDateSelected: (d) => _birthDate = d,
            ),

            const SizedBox(height: 16),

            // Gender
            GenderSelector(
              label: S.of(context).Gender,
              initialGender: _gender,
              validator: (g) =>
                  g == null ? S.of(context).PleaseSelectGender : null,
              onGenderSelected: (g) => _gender = g,
            ),

            const SizedBox(height: 24),

            // Save button
            CustomButton(
              text: S.of(context).Save,
              width: double.infinity,
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  final dobStr = _birthDate == null
                      ? null
                      : DateFormat('yyyy-MM-dd').format(_birthDate!);
                  cubit.updatePersonalData(
                    fullName: _fullName,
                    phone: _phone,
                    country: _country?.name,
                    city: _city,
                    dateOfBirth: dobStr,
                    gender: _gender,
                  );
                } else {
                  setState(() => _autoValidate = AutovalidateMode.always);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
