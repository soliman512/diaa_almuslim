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

  Future<void> addNewZikr(Map<String, dynamic> newZikr) async {
    try {
      await ensureFileExists();
      final file = await _localFile;
      String content = await file.readAsString();
      List azkarList = await jsonDecode(content);
      azkarList.add(newZikr);
      await file.writeAsString(jsonEncode(azkarList));
    } catch (e) {
      print("there is exception in add new zikr\n e: $e");
    }
  }

  Future<List<Map<String, dynamic>>> loadUserAzkar() async {
    try {
      await ensureFileExists();

      final file = await _localFile;

      String content = await file.readAsString();

      List decodedData = jsonDecode(content);

      return List<Map<String, dynamic>>.from(decodedData);
    } catch (e) {
      print("there is exception in load user azkar\n e: $e");
      return [];
    }
  }

  Future<void> removeZikr(int zikrId) async {
    try {
      final file = await _localFile;
      String content = await file.readAsString();
      List azkarList = jsonDecode(content);
      azkarList.removeWhere((item) => item['id'] == zikrId);
      await file.writeAsString(jsonEncode(azkarList));
    } catch (e) {
      print("there is exception in remove zikr\n e: $e");
    }
  }
}
