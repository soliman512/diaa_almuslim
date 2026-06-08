import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:zad_almuslim/core/constants/json_files.dart';

class SebhaLogic {
  static Future<List<dynamic>> loadSebhaAzkar() async {
    try {
      final jsonString = await rootBundle.loadString(ConstJsonFiles.sebhaAzkar);

      final List<dynamic> data = json.decode(jsonString);

      return data;
    } catch (e) {
      return [
        {"id": 0, "content": "لا يوجد أذكار متاحة حالياً"},
      ];
    }
  }
}
