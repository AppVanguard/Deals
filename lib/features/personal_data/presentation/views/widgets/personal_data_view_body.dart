// lib/features/profile/presentation/views/personal_data_view_body.dart

import 'package:deals/core/utils/app_colors.dart';
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
  // dirty‐flags & new‐value holders
  bool _fullNameDirty = false;
  late String _newFullName;

  bool _phoneDirty = false;
  late String _newPhone;

  bool _countryDirty = false;
  Country? _newCountry;

  bool _cityDirty = false;
  late String _newCity;

  bool _birthDateDirty = false;
  DateTime? _newBirthDate;

  bool _genderDirty = false;
  String? _newGender;

  @override
  void initState() {
    super.initState();
    // seed with original values for UI
    _newFullName = widget.user.fullName;
    _newPhone = widget.user.phone;
    _newCity = widget.user.city ?? '';
    if (widget.user.country != null) {
      _newCountry = Country.parse(widget.user.country!);
    }
    _newBirthDate = widget.user.dateOfBirth;
    _newGender = widget.user.gender;
  }

  void _mark(String field, dynamic value) {
    switch (field) {
      case 'fullName':
        _fullNameDirty = true;
        _newFullName = value as String;
        break;
      case 'phone':
        _phoneDirty = true;
        _newPhone = value as String;
        break;
      case 'country':
        _countryDirty = true;
        _newCountry = value as Country;
        break;
      case 'city':
        _cityDirty = true;
        _newCity = value as String;
        break;
      case 'birthDate':
        _birthDateDirty = true;
        _newBirthDate = value as DateTime;
        break;
      case 'gender':
        _genderDirty = true;
        _newGender = value as String;
        break;
    }
  }

  void _onSave() {
    final dobString = _birthDateDirty && _newBirthDate != null
        ? DateFormat('yyyy-MM-dd').format(_newBirthDate!)
        : null;

    context.read<PersonalDataCubit>().updatePersonalData(
          fullName: _fullNameDirty ? _newFullName : null,
          phone: _phoneDirty ? _newPhone : null,
          country: _countryDirty ? _newCountry?.name : null,
          city: _cityDirty ? _newCity : null,
          dateOfBirth: _birthDateDirty ? dobString : null,
          gender: _genderDirty ? _newGender : null,
        );
  }

  @override
  Widget build(BuildContext context) {
    final S strings = S.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Email (read-only)
          CustomTextFormField(
            label: strings.Email,
            hintText: widget.user.email,
            initialValue: widget.user.email,
            textInputType: TextInputType.emailAddress,
            validator: (_) => null,
            enabled: false,
            disabledFillColor: AppColors.darkGray,
            disabledTextColor: AppColors.text,
          ),

          const SizedBox(height: 16),

          // Full name
          CustomTextFormField(
            label: strings.FullName,
            hintText: _newFullName,
            initialValue: _newFullName,
            textInputType: TextInputType.name,
            validator: (_) => null,
            onChanged: (v) => _mark('fullName', v),
          ),

          const SizedBox(height: 16),

          // Phone
          CustomPhoneField(
            label: strings.Phone,
            initialCountryCode: _newCountry?.countryCode ?? 'EG',
            initialValue: _newPhone,
            validator: (_) => null,
            onChanged: (pn) => _mark('phone', pn.completeNumber),
          ),

          const SizedBox(height: 16),

          // Country
          CountrySelectorField(
            label: strings.Country,
            initialCountry: _newCountry,
            validator: (_) => null,
            onCountrySelected: (c) => _mark('country', c),
          ),

          const SizedBox(height: 16),

          // City / Town
          CustomTextFormField(
            label: strings.City,
            hintText: _newCity,
            initialValue: _newCity,
            textInputType: TextInputType.text,
            validator: (_) => null,
            onChanged: (v) => _mark('city', v),
          ),

          const SizedBox(height: 16),

          // Birth date
          CustomDatePicker(
            initialDate: _newBirthDate,
            validator: (_) => null,
            onDateSelected: (d) => _mark('birthDate', d),
          ),

          const SizedBox(height: 16),

          // Gender
          GenderSelector(
            label: strings.Gender,
            initialGender: _newGender,
            validator: (_) => null,
            onGenderSelected: (g) => _mark('gender', g),
          ),

          const SizedBox(height: 24),

          // Save button with loading spinner
          BlocBuilder<PersonalDataCubit, PersonalDataState>(
            buildWhen: (_, state) =>
                state is PersonalDataUpdateInProgress ||
                state is PersonalDataUpdateSuccess ||
                state is PersonalDataUpdateFailure,
            builder: (ctx, state) {
              final isLoading = state is PersonalDataUpdateInProgress;
              return CustomButton(
                text: strings.Save,
                width: double.infinity,
                onPressed: _onSave,
                isLoading: isLoading,
              );
            },
          ),
        ],
      ),
    );
  }
}
