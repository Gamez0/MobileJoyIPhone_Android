import 'package:mobilejoy/splash_screen.dart';

import 'login/LoginRegisterPage.dart';
import 'package:flutter/material.dart';
import 'pages/HomePage.dart';
import 'login/Mapping.dart';
import 'login/Authentication.dart';
import 'package:mobilejoy/util/const.dart';


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
    );  
  }
}