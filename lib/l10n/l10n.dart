

import 'package:flutter/material.dart';

class L10n {
  static final all = [
    const Locale('vi'),
    const Locale('en')
  ];

  static String getName(String code) {
    switch (code) {
      case 'vi':
        return 'Tiếng Việt';
      case 'en':
        return 'English';
      default:
        return 'Tiếng Việt';
    }
  }

}