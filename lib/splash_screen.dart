import 'dart:math';
import 'package:flutter/material.dart';
import 'package:mobilejoy/login/Mapping.dart';
import 'dart:async';
import 'login/Authentication.dart';


class SplashScreen extends StatefulWidget {
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>{
  String splashText;
  bool after3=false;
  ImageProvider splashIcon;
  final List<String> item = [
    "찬양","기도","성경","말씀","큐티"
  ];
  final List<ImageProvider> imageItem =[
    AssetImage("images/guitar.png"),AssetImage("images/pray.png"),AssetImage("images/bible.png"),AssetImage("images/sermon.png"),AssetImage("images/qt.png"),
    AssetImage("images/guitar_clicked.png"),AssetImage("images/pray_clicked.png"),AssetImage("images/bible_clicked.png"),AssetImage("images/sermon_clicked.png"),AssetImage("images/qt_clicked.png"),
  ];

  @override
  void initState(){
    super.initState();
    Random random = new Random();
    int num = random.nextInt(5);
    
    splashText=item[num]+" 준비 중...";
    splashIcon=imageItem[num];
  
    Timer(Duration(seconds: 3), () {
      setState(() {
        splashText=item[num]+" 준비 끝!";
        splashIcon=imageItem[num+5];
        after3=true;
      });
    });
    Timer(Duration(seconds: 5), () => _navigationToHome());

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
    precacheImage(AssetImage("images/guitar.png"), context);
    precacheImage(AssetImage("images/guitar_clicked.png"), context);
    precacheImage(AssetImage("images/pray.png"), context);
    precacheImage(AssetImage("images/pray_clicked.png"), context);
    precacheImage(AssetImage("images/bible.png"), context);
    precacheImage(AssetImage("images/bible_clicked.png"), context);
    precacheImage(AssetImage("images/sermon.png"), context);
    precacheImage(AssetImage("images/sermon_clicked.png"), context);
    precacheImage(AssetImage("images/qt.png"), context);
    precacheImage(AssetImage("images/qt_clicked.png"), context);
    return Scaffold(
      body: Stack(
          fit: StackFit.expand,
          // alignment: Alignment.center,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(color: Colors.white),
            ),
            Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
            Expanded(
                flex: 2,
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(top: 10.0),
                      ),
                      Text(
                        "모바일\n죠이",
                        style: TextStyle(
                            // color: Theme.of(context).accentColor,
                            // fontWeight: FontWeight.bold,
                            fontSize: 35.0),
                            textAlign: TextAlign.center,
                      )
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[

                    Image(image: splashIcon, height: 50, width: 50,),
                    Padding(
                      padding: EdgeInsets.only(top: 20.0),
                    ),
                    Text(
                      splashText,
                      softWrap: true,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          // fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                          color: Colors.grey),
                     )
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}