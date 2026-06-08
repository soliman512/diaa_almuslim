import 'dart:convert';
import 'package:flutter/services.dart';

class AzkarLogic{
static Future<List> loadAzkar(String jsonPath)async{
  final jsonString = await rootBundle.loadString(jsonPath);
  final data = await json.decode(jsonString);
  return data;
}

}