import 'package:flutter/material.dart';
import 'package:mobilejoy/login/Mapping.dart';
import 'dart:async';
import 'login/Authentication.dart';
import 'package:shimmer/shimmer.dart';


class SplashScreen extends StatefulWidget {
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>{
  
  @override
  void initState(){
    super.initState();

    _mockCheckForSession().then(
      (status){
        _navigationToHome();
      }
    );
  }

  Future<bool> _mockCheckForSession() async{
    await Future.delayed(Duration(milliseconds: 4000),(){});

    return true;
  }

  void _navigationToHome(){
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (BuildContext context) => MappingPage(auth: Auth(), ),
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Container(
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Opacity(
              opacity: 0.5,
              child: Image.asset('images/bg.jpg'),
            ),
            Shimmer.fromColors(
              baseColor: Colors.black12, 
              highlightColor: Colors.black,
              child: Center(
                // padding: EdgeInsets.all(16.0),
                child: Text("모바일 죠이", style: TextStyle(
                    fontSize: 50.0,
                    fontFamily: 'poetAndMe',
                    // shadows: <Shadow>[
                    //   Shadow(
                    //     blurRadius: 18.0,
                    //     color: Colors.black87,
                    //     offset: Offset.fromDirection(120,12),
                    //   )
                    // ]
                    ),
                  ),
                ), 
              
              )
          ],
        ),
      )
      );
  }
}