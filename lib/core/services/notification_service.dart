import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:diaa_almuslim/core/models/prayer_model.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  Future<void> init() async {
    await AwesomeNotifications().initialize(
      null, 
      [
        NotificationChannel(
          channelKey: 'azkar_channel',
          channelName: 'أذكار الصباح والمساء',
          channelDescription: 'تنبيهات الأذكار اليومية في 5 صباحاً ومساءً',
          importance: NotificationImportance.High,
          playSound: true,
        ),
        NotificationChannel(
          channelKey: 'prayer_channel',
          channelName: 'تنبيهات الصلاة',
          channelDescription: 'تنبيهات مواقيت الصلاة المتغيرة',
          importance: NotificationImportance.High,
          playSound: true,
        )
      ],
    );
  }

  Future<void> requestPermissions() async {
    bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
    if (!isAllowed) {
      await AwesomeNotifications().requestPermissionToSendNotifications();
    }
  }

  Future<void> scheduleDailyAzkar() async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 100, 
        channelKey: 'azkar_channel',
        title: 'أذكار الصباح ☀️',
        body: 'افتتح يومك بذكر الله، دقائق قليلة تملأ يومك خيرًا',
      ),
      schedule: NotificationCalendar(
        hour: 5,
        minute: 0,
        second: 0,
        repeats: true,
      ),
    );

    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 101,
        channelKey: 'azkar_channel',
        title: 'أذكار المساء 🌙',
        body: 'اختم يومك بذكر الله، وحصّن نفسك بأذكار المساء',
      ),
      schedule: NotificationCalendar(
        hour: 17, 
        minute: 0,
        second: 0,
        repeats: true,
      ),
    );
  }

  Future<void> schedulePrayers(List<PrayerModel> prayers) async {
    int baseId = 200;
    
    for (int i = 0; i < prayers.length; i++) {
      final prayer = prayers[i];
      
      if (prayer.time.isAfter(DateTime.now())) {
        await AwesomeNotifications().createNotification(
          content: NotificationContent(
            id: baseId + i,
            channelKey: 'prayer_channel',
            title: 'حي على الصلاة',
            body: 'حان الان موعد صلاة ال${prayer.name}',
          ),
          schedule: NotificationCalendar.fromDate(
            date: prayer.time,
          ),
        );
      }
    }
  }
}