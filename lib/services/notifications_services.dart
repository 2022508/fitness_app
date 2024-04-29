// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:fitness_app/main.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'dart:developer';

class NotificationServices {
  static Future<void> initialiseNotification() async {
    await AwesomeNotifications().initialize(
        null,
        [
          NotificationChannel(
            channelKey: 'app_update',
            channelName: 'App Update',
            channelDescription: 'This is a fintess app',
            channelGroupKey: 'fintess_app',
            importance: NotificationImportance.Max,
            onlyAlertOnce: true,
            playSound: true,
            criticalAlerts: true,
            defaultColor: Color(0xFF9D50DD),
            ledColor: Colors.white,
          ),
        ],
        channelGroups: [
          NotificationChannelGroup(
              channelGroupKey: 'fintess_app', channelGroupName: 'Fitness App'),
        ],
        debug: true);

    await AwesomeNotifications().setListeners(
      onActionReceivedMethod: onActionReceivedMethod,
      onNotificationCreatedMethod: onNotificationCreatedMethod,
      onNotificationDisplayedMethod: onNotificationDisplayedMethod,
      onDismissActionReceivedMethod: onDismissActionReceivedMethod,
    );
  }

  static Future<void> onActionReceivedMethod(
      ReceivedAction receivedAction) async {
    final payload = receivedAction.payload ?? {};
    if (payload['navigate'] == 'true') {
      navigatorKey.currentState?.push(
        MaterialPageRoute(
          builder: (_) => (MyApp()),
        ),
      );
    }
  }

  static Future<void> onNotificationCreatedMethod(
      ReceivedNotification receivedNotification) async {
    log('Notification created');
  }

  static Future<void> onNotificationDisplayedMethod(
      ReceivedNotification receivedNotification) async {
    log('Notification displayed');
  }

  static Future<void> onDismissActionReceivedMethod(
      ReceivedAction receivedAction) async {
    log('Notification dismissed');
  }

  static Future<void> displayNotification(
      {required String body,
      final String? title,
      final String? summary,
      final Map<String, String>? payload,
      final ActionType actionType = ActionType.Default,
      final NotificationLayout notificationLayout = NotificationLayout.Default,
      final NotificationCategory? category,
      final String? bigPicture,
      final List<NotificationActionButton>? actionButtons,
      bool scheduled = false,
      final int? interval}) async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 0,
        channelKey: 'app_update',
        title: title,
        body: body,
        summary: summary,
        payload: payload,
        actionType: actionType,
        notificationLayout: notificationLayout,
        category: category,
        bigPicture: bigPicture,
      ),
      actionButtons: actionButtons,
      schedule: scheduled
          ? NotificationInterval(
              interval: interval,
              timeZone:
                  await AwesomeNotifications().getLocalTimeZoneIdentifier(),
              preciseAlarm: true)
          : null,
    );
  }

  static Future<void> cancelNotification() async {
    await AwesomeNotifications().cancelAllSchedules();
    log('Notification cancelled');
  }

  static Future<bool> checkPermission() async {
    final permissionGranted =
        await AwesomeNotifications().isNotificationAllowed();
    log('Permission granted: $permissionGranted');
    return permissionGranted;
  }
}
