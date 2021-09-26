import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:getmecar/services/local_notifications_service.dart';

abstract class FCMService {
  static Future<void> onBackgroundMessageFunction(RemoteMessage message) async {
    await Firebase.initializeApp();
    print('NEW BACKGROUND MESSAGE:\ntitle: ${message.notification!.title}');
    NotificationsService.pushNotification(
        title: message.notification!.title ?? '', body: message.notification!.body ?? '');
  }

  static Future<void> onForegroundMessageFunction(RemoteMessage message) async {
    print('NEW FOREGROUND MESSAGE:\ntitle: ${message.notification!.title}');
    NotificationsService.pushNotification(
        title: message.notification!.title ?? '', body: message.notification!.body ?? '');
  }
}
