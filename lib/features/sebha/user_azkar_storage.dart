import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';

class UserAzkarStorage {
  static const String _fileName = "user_azkar_storage.json";

  Future<File> get _localFile async {
    final directory = await getApplicationDocumentsDirectory();
    return File("${directory.path}/$_fileName");
  }

  Future<void> ensureFileExists() async {
    final file = await _localFile;
    if (!(await file.exists())) {
      await file.writeAsString(jsonEncode([]));
    }
  }

  // إضافة ذكر جديد كـ String
  Future<void> addNewZikr(String zikrText) async {
    try {
      await ensureFileExists();
      final file = await _localFile;
      List<String> azkarList = await loadUserAzkar();
      azkarList.add(zikrText);
      await file.writeAsString(jsonEncode(azkarList));
    } catch (e) {
      print("Exception in add new zikr: $e");
    }
  }

  // تحميل قائمة الأذكار كـ List<String>
  Future<List<String>> loadUserAzkar() async {
    try {
      await ensureFileExists();
      final file = await _localFile;
      String content = await file.readAsString();
      List decodedData = jsonDecode(content);
      return List<String>.from(decodedData);
    } catch (e) {
      print("Exception in load user azkar: $e");
      return [];
    }
  }

  Future<void> removeZikrAt(int index) async {
    try {
      final file = await _localFile;
      List<String> azkarList = await loadUserAzkar();
      if (index >= 0 && index < azkarList.length) {
        azkarList.removeAt(index);
        await file.writeAsString(jsonEncode(azkarList));
      }
    } catch (e) {
      print("Exception in remove zikr: $e");
    }
  }
}