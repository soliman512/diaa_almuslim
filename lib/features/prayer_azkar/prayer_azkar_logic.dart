import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zad_almuslim/core/constants/json_files.dart';

class PrayerAzkarLogic {
 static Future<List> getPrayerAzkar() async {
    final jsonString = await rootBundle.loadString(ConstJsonFiles.prayerAzkar);
    final data = await json.decode(jsonString);
    return data;
  }
}