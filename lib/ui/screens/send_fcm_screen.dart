import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class SendFcmScreen extends StatelessWidget {
  const SendFcmScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Send Fcm Screen"),
      ),
      body: Container(
        child: Center(
          child: ElevatedButton(
              onPressed: () async {
                Dio dio = Dio(
                  BaseOptions(
                    baseUrl: "https://fcm.googleapis.com/fcm/",
                    headers: {
                      "Content-Type": "application/json",
                      "Authorization":
                          "key=AAAAbBXsX1M:APA91bEc0Hx4oogAQEjPi4M09KtYNEJDc2x0pRDpKQYQR3-SWxewgw_Q3j7Tt8jlX-KNeoZnq035Yw8bMp_JzFpgwQoQ8FNxSYsB4enSgRlj3cpPQrslI8ILAOUfHmSfKg7cvV6vx86V",
                    },
                    receiveDataWhenStatusError: true,
                  ),
                );
                await dio.post(
                  "send",
                  data: {
                    "to":
                        "dtjxir9JRxGoQ1e_2EGSIC:APA91bEW7RZzfEJynw6YcdJiZvHKLkLAhcFu5ZTVExXAZS17J6UZuE1u9AzktCIc2zqyKqoqJc1lM4w5iGCIMD3w36Fstr1eDzSUzKRsvEGTVNwGY108OHzdTH2eXi31KLD8-saipSlP",
                    "notification": {
                      "title": "send from api",
                      "body": "body",
                      "sound": "default"
                    },
                    "android": {
                      "priority": "HIGH",
                      "notification": {
                        "notification_priority": "PRIORITY_MAX",
                        "sound": "default",
                        "default_sound": true,
                        "default_vibrate_timings": true,
                        "default_light_settings": true
                      }
                    },
                    "data": {
                      "type": "order",
                      "id": "87",
                      "click_action": "FLUTTER_NOTIFICATION_CLICK"
                    }
                  },
                );
              },
              child: Text("send Notification")),
        ),
      ),
    );
  }
}
