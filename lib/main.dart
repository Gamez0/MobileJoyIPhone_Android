import 'package:mobilejoy/splash_screen.dart';

import 'login/LoginRegisterPage.dart';
import 'package:flutter/material.dart';
import 'pages/HomePage.dart';
import 'login/Mapping.dart';
import 'login/Authentication.dart';
import 'package:mobilejoy/util/const.dart';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';


void main(){
    runApp(new JoyApp());
}


class JoyApp extends StatelessWidget{
    @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: "Mobile Joy", 
      theme: Constants.lightTheme,
      home: SplashScreen(),
      // home: MyHomePage(),
    );  
  }
}


// import 'package:flutter/material.dart';

// import 'dart:io';
// import 'package:firebase_messaging/firebase_messaging.dart'; 

// final FirebaseMessaging _firebaseMessaging = FirebaseMessaging(); 

// void main() => runApp(JoyApp());

// class JoyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: Scaffold(
//         appBar: AppBar(
//           title: Text('FCM'),
//         ),
//         body: MyHomePage(),
//       ),
//     );
//   }
// }

// class MyHomePage extends StatefulWidget {

//   @override
//   State<StatefulWidget> createState() {
//     return _MyHomePage();
//   }
// }

// class _MyHomePage extends State<MyHomePage> {

//   @override
//   void initState() {
//     super.initState();
//     firebaseCloudMessaging_Listeners();
//   }

//   @override
//   Widget build(BuildContext context) {

//     return Center(
//       child: Text(
//         'Test',
//       ),
//     );
//   }

//   void firebaseCloudMessaging_Listeners() {
//     if (Platform.isIOS) iOS_Permission();

//     _firebaseMessaging.getToken().then((token){
//       print('token:'+token);
//     });

//     _firebaseMessaging.configure(
//       onMessage: (Map<String, dynamic> message) async {
//         print('on message $message');
//       },
//       onResume: (Map<String, dynamic> message) async {
//         print('on resume $message');
//       },
//       onLaunch: (Map<String, dynamic> message) async {
//         print('on launch $message');
//       },
//     );
//   }

//   void iOS_Permission() {
//     _firebaseMessaging.requestNotificationPermissions(
//         IosNotificationSettings(sound: true, badge: true, alert: true)
//     );
//     _firebaseMessaging.onIosSettingsRegistered
//         .listen((IosNotificationSettings settings)
//     {
//       print("Settings registered: $settings");
//     });
//   }
// }