import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationScreen extends StatefulWidget {
  @override
  State<LocalNotificationScreen> createState() =>
      _LocalNotificationScreenState();
}

class _LocalNotificationScreenState extends State<LocalNotificationScreen> {
  FlutterLocalNotificationsPlugin? flutterNotifications;

  @override
  void initState() {
    super.initState();
    var androidInit = AndroidInitializationSettings("ic_launcher");
    var iosInit = IOSInitializationSettings();
    var initSettings =
        InitializationSettings(android: androidInit, iOS: iosInit);
    flutterNotifications = FlutterLocalNotificationsPlugin();
    flutterNotifications!
        .initialize(initSettings, onSelectNotification: selectNotification);
  }


  _showNotification() async {
    var androidDetails = AndroidNotificationDetails(
      "Channel Id",
      "Channel Name",
      importance: Importance.max,
      playSound: true,
    );
    var iosDetails = IOSNotificationDetails();
    var generalNotificationDetails =
        NotificationDetails(android: androidDetails, iOS: iosDetails);
    await flutterNotifications!
        .show(0, "title", "body", generalNotificationDetails, payload: "task");
  }

  _showScheduleNotification() async {
    var androidDetails = AndroidNotificationDetails(
      "Channel Id",
      "Channel Name",
      importance: Importance.max,
      playSound: true,
    );
    var iosDetails = IOSNotificationDetails();
    var generalNotificationDetails =
        NotificationDetails(android: androidDetails, iOS: iosDetails);
    var scheduledTime = DateTime.now().add(Duration(seconds : 2));
    flutterNotifications!.schedule(1, "Times Uppp", "task",
        scheduledTime, generalNotificationDetails);
    // Stream.periodic(Duration(seconds: 5)).listen((event) async {
    //   await flutterNotifications!.show(
    //       0, "title", "body", generalNotificationDetails,
    //       payload: "task");
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
                onPressed: _showNotification,
                child: Text("Simple Notification")),
            ElevatedButton(
                onPressed: _showScheduleNotification,
                child: Text("Scheduled Notification")),
            ElevatedButton(
                onPressed: () {
                  flutterNotifications!.cancelAll();
                },
                child: Text("Remove Notification")),
          ],
        ),
      ),
    );
  }

  selectNotification(String? payLoad) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Text("Notification Clicked $payLoad"),
      ),
    );
  }
}
