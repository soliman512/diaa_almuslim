import 'package:intl/intl.dart';

class DateManager {
  static String getFormattedTime(DateTime time) {
    return DateFormat('h:mm').format(time);
  }

  static bool isMorning() {
    int hour = DateTime.now().hour;
    return hour >= 4 && hour < 16;
  }

  static String getCurrentNafha() {
    int hour = DateTime.now().hour;

    if (hour >= 2 && hour < 4) {
      return "نَفَحات السَّحَر";
    } else if (hour >= 4 && hour < 8) {
      return "بَرَكة البُكور";
    } else if (hour >= 8 && hour < 12) {
      return "ساعات الضحى";
    } else if (hour >= 12 && hour < 16) {
      return "في ظلال الظهر";
    } else if (hour >= 16 && hour < 19) {
      return "مرافئ المساء";
    } else {
      return "سكينة الليل";
    }
  }
}