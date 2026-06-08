import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:zad_almuslim/core/constants/json_files.dart';

class MerajLogic {
  static const String _jsonFilePath = ConstJsonFiles.meraj;
  static Future<List> loadData() async {
    try {
      final String jsonString = await rootBundle.loadString(_jsonFilePath);
      final List data = jsonDecode(jsonString);
      return data;
    } catch (e) {
      throw Exception(
        "there is exception accurred in loadData from meraj.json : $e",
      );
    }
  }
}
