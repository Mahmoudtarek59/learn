import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session_10/ui/screens/auth_screen.dart';
import 'package:flutter_session_10/ui/screens/learn3.dart';
import 'package:flutter_session_10/ui/screens/learn_firestore.dart';
import 'package:flutter_session_10/ui/screens/learn_screen.dart';
import 'package:flutter_session_10/ui/screens/local_notitication_screen.dart';
import 'package:flutter_session_10/ui/screens/scroll_positioned_screen.dart';
import 'package:flutter_session_10/ui/screens/send_fcm_mes_screen.dart';
import 'package:flutter_session_10/ui/screens/send_fcm_screen.dart';
import 'package:flutter_session_10/ui/screens/test_List_screen.dart';
import 'package:flutter_session_10/ui/screens/upload_image_screen.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

// Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   print("reading------------ ${message.data}");
//   print("reading------------ ${message.notification!.body}");
//
//   Fluttertoast.showToast(
//       msg: message.notification!.body.toString(),
//       toastLength: Toast.LENGTH_SHORT,
//       gravity: ToastGravity.CENTER,
//       timeInSecForIosWeb: 1,
//       backgroundColor: Colors.red,
//       textColor: Colors.white,
//       fontSize: 16.0
//   );
// }

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  Fluttertoast.showToast(
      msg: message.notification!.body.toString(),
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0);
}

class MyApp extends StatefulWidget {
  // FirebaseMessaging firebaseMessaging = FirebaseMessaging();

  // This widget is the root of your application.
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  getToken() async {
    String? token = await FirebaseMessaging.instance.getToken();
    print(token);
  }

  _not() {
    FirebaseMessaging.onMessage.listen((event) {
      print(event.data);
      Fluttertoast.showToast(
          msg: event.notification!.body.toString(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    });
    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      print(event.notification!.title.toString());
      Fluttertoast.showToast(
        msg: event.notification!.body.toString(),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(event.notification!.title!)));
    });
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
    // FirebaseMessaging.instance.sendMessage()
  }

  // cU7TfkUSRm-DdKlQ1KgbkG:APA91bEetHoIZsg1QXgSndo_VSEqJYxF0KB6744t0hxyt2XQiXIDHjFr3t6xQYQWDZurMaPNXNoYribxtin7L2won4bof5GYdC4ab9cwzQde4gVe0cM0aF4oRu1C0dAKmAIOa1ya_WQL

  // getToken() async {
  //   var token = await FirebaseMessaging.instance.getToken();
  //   print(token);
  //   // FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(alert: true,sound: true,badge: true);
  //
  //   //لو انت فاتح التطبيق وجالك نوتيفيكيشن
  //   FirebaseMessaging.onMessage.listen((event) {
  //     print("reading------------ ${event.data}");
  //     print("reading------------ ${event.notification!.body}");
  //     // Fluttertoast.showToast(
  //     //     msg: event.notification!.body.toString(),
  //     //     toastLength: Toast.LENGTH_SHORT,
  //     //     gravity: ToastGravity.CENTER,
  //     //     timeInSecForIosWeb: 1,
  //     //     backgroundColor: Colors.red,
  //     //     textColor: Colors.white,
  //     //     fontSize: 16.0
  //     // );
  //   });
  //
  //   //لو انت قافل التطبيق وهو فى ال on resume مش مقفول تماما يعنى وجالك نوتيكفيكيشن
  //   FirebaseMessaging.onMessageOpenedApp.listen((event) {
  //     print("reading------------ ${event.data}");
  //     print("reading------------ ${event.notification!.body}");
  //     Fluttertoast.showToast(
  //         msg: event.notification!.body.toString(),
  //         toastLength: Toast.LENGTH_SHORT,
  //         gravity: ToastGravity.CENTER,
  //         timeInSecForIosWeb: 1,
  //         backgroundColor: Colors.red,
  //         textColor: Colors.white,
  //         fontSize: 16.0);
  //   });
  //
  //   //و التطبيق مقفول تماماااا
  //   FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  // }

  @override
  Widget build(BuildContext context) {
    // print(FirebaseMessaging.instance.getToken());
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home:
      // LocalNotificationScreen(),
      StreamBuilder<User?>(
        stream: FirebaseAuth.instance.userChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            if (snapshot.data == null) {
              return AuthScreen();
            } else {
              return LearnFirestore();
            }
          }
        },
      ),
    );
  }

  @override
  void initState() {
    getToken();
    _not();
  }
}
