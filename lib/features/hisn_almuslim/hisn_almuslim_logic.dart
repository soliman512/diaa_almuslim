import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zad_almuslim/core/constants/json_files.dart';

class HisnAlmuslimLogic {
  static Future<dynamic> getData() async {
    final jsonString = await rootBundle.loadString(ConstJsonFiles.hisnAlmuslim);
    final data = await json.decode(jsonString);
    return data;
  }
}
