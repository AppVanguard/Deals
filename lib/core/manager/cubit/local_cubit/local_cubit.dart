import 'dart:ui';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'local_state.dart';

class LocaleCubit extends Cubit<Locale> {
  LocaleCubit() : super(const Locale('en')); // Default to English

  void setLocale(Locale locale) {
    emit(locale); // Emit the new locale
  }
}
