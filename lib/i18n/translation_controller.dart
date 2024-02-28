
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TranslationController extends GetxController {
  get lang => null;

  void changeLanguage(String langCode) {
    List<String> langs = langCode.split('_');
    String lang = langs[0];
    int count = langs.length;
    String country = count > 1 ? langs[count - 1] : '';
    Locale local = Locale(lang, country);
    Get.locale = local;
    Get.updateLocale(local);
  }
}