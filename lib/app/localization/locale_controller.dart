import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LocaleController extends Notifier<Locale> {
  @override
  Locale build() {
    return const Locale('en');
  }

  void setEnglish() {
    state = const Locale('en');
  }

  void setArabic() {
    state = const Locale('ar');
  }

  void toggleLanguage() {
    state = state.languageCode == 'en'
        ? const Locale('ar')
        : const Locale('en');
  }
}

final localeProvider =
NotifierProvider<LocaleController, Locale>(
  LocaleController.new,
);