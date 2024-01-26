import 'dart:convert';
import 'dart:io';
// import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
// import 'package:flutter_app_version_checker/flutter_app_version_checker.dart';
import 'package:newfcheckproject/authenticationLogin.dart';
import 'package:newfcheckproject/offlineDatabase/sqfLiteDatabase.dart';
//import 'firebase_options.dart';
import 'home/homeScreen.dart';
import 'officeAndWFH/officeAndWFH.dart';
import 'dashboardPage.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   // If you're going to use other Firebase services in the background, such as Firestore,
//   // make sure you call initializeApp before using other Firebase services.
//   // await Firebase.initializeApp();
//
//   print("Handling a background message: ${message.messageId}");
// }
void main() async{
  //WidgetsFlutterBinding.ensureInitialized();


  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  //Remove this method to stop OneSignal Debugging
  OneSignal.Debug.setLogLevel(OSLogLevel.verbose);

  OneSignal.initialize("6087a792-7c1a-4bb1-9970-09e520fbcd58");

// The promptForPushNotificationsWithUserResponse function will show the iOS or Android push notification prompt. We recommend removing the following code and instead using an In-App Message to prompt for notification permission
  OneSignal.Notifications.requestPermission(true);

  // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  // FirebaseMessaging messaging = FirebaseMessaging.instance;
  // await messaging.subscribeToTopic('ontimeMobile');
  // NotificationSettings settings = await messaging.requestPermission(
  //   alert: true,
  //   announcement: false,
  //   badge: true,
  //   carPlay: false,
  //   criticalAlert: false,
  //   provisional: false,
  //   sound: true,
  // );
  //
  // FirebaseMessaging.onMessage.listen((RemoteMessage message) {
  //   print('Got a message whilst in the foreground!');
  //   print('Message data: ${message.data}');
  //
  //   if (message.notification != null) {
  //
  //     print('Message also contained a notification: ${message.notification}');
  //     print('Notification Title: ${message.notification!.title}');
  //     print('Notification Body: ${message.notification!.body}');
  //   }
  // });

/*  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform);*/

  var type = await DBProvider.db.getEmployeesData("Id");

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: type.toString() != "null"?"/homeScreen":"/authenticationLogin",
    routes: {
      "/authenticationLogin": (context) =>const authenticationLogin(),
      "/homeScreen": (context) => const homeScreen(),
      "/dashboard": (context) => const dashboard(),
      // "/officeAndWFH": (context) => const officeAndWFH(),
    },
  ));
}
class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext? context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}

