import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';

class MerajUserCompletedAzkar {
  static const String _fileName = 'merajUserCompletedAzkar';
  Future<File> get _localFile async {
    final directory = await getApplicationDocumentsDirectory();
    return File("${directory.path}/$_fileName");
  }

  Future<void> ensureFileExists() async {
    final file = await _localFile;
    try {
      if (!(await file.exists())) {
        await file.writeAsString(jsonEncode([]));
      }
    } catch (e) {
      throw Exception("problem in ensureFileExists \n e: $e");
    }
  }

  Future<void> addNewZikr(int zikrId) async {
    try {
      await ensureFileExists();
      final file = await _localFile;
      String content = await file.readAsString();
      List azkarList = await jsonDecode(content);

      if (!azkarList.contains(zikrId)) {
        azkarList.add(zikrId);
        await file.writeAsString(jsonEncode(azkarList));
      }
      print(file.readAsString());
      print("successssssssssssssssssssssssssssssssssssed!!!");
    } catch (e) {
      throw Exception("problem in addNewZikr \n e: $e");
    }
  }

  Future<bool> checkIsZikrCompleted(int zikrId) async {
    try {
      await ensureFileExists();
      final file = await _localFile;
      String content = await file.readAsString();
      List azkarList = await jsonDecode(content);
      if (azkarList.contains(zikrId)) {
        return true;
      }
      return false;
    } catch (e) {
      throw Exception("problem in checkIsZikrCompleted \n e: $e");
    }
  }
}
