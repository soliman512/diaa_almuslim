import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:diaa_almuslim/core/constants/json_files.dart';

class SebhaLogic {
  static Future<List<String>> loadSebhaAzkar() async {
    try {
      final jsonString = await rootBundle.loadString(ConstJsonFiles.sebhaAzkar);

      final List<dynamic> data = json.decode(jsonString);

      return data.map((item) => item['content'].toString()).toList();
    } catch (e) {
      return ["لا يوجد أذكار متاحة حالياً"];
    }
  }
}