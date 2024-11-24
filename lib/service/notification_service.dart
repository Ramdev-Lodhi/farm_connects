import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    const AndroidInitializationSettings androidInitializationSettings =
    AndroidInitializationSettings('@mipmap/farm_connects_new');
    final InitializationSettings initializationSettings =
    InitializationSettings(android: androidInitializationSettings);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  static Future<void> showNotification({
    required String title,
    required String body,
    String? imageUrl,
  }) async {
    String? localImagePath;

    // Download image using Dio if URL is provided
    if (imageUrl != null) {
      try {
        final Dio dio = Dio();
        final Directory tempDir = await getTemporaryDirectory();
        final String filePath = '${tempDir.path}/notification_image.jpg';

        // Download and save the image
        await dio.download(imageUrl, filePath);
        localImagePath = filePath;
      } catch (e) {
        print('Error downloading image with Dio: $e');
      }
    }

    // Configure BigPictureStyleInformation for expanded view
    final BigPictureStyleInformation? bigPictureStyleInformation =
    localImagePath != null
        ? BigPictureStyleInformation(
      FilePathAndroidBitmap(localImagePath),
      contentTitle: title,
      htmlFormatContentTitle: true,
      summaryText: body,
      htmlFormatSummaryText: true,
    )
        : null;

    // Configure collapsed view with a small right-side image (using largeIcon)
    final AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'channel_id',
      'channel_name',
      importance: Importance.max,
      priority: Priority.high,
      largeIcon: localImagePath != null
          ? FilePathAndroidBitmap(localImagePath)
          : null,
      styleInformation: bigPictureStyleInformation,
    );

    final NotificationDetails platformDetails =
    NotificationDetails(android: androidDetails);

    // Show notification
    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      platformDetails,
    );
  }
}
