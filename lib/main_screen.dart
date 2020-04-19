import 'package:flutter/material.dart';
import 'package:mobilejoy/joyicon_icons.dart';
import 'pages/HomePage.dart';
import 'pages/ProfilePage.dart';
import 'pages/QTPage.dart';
import 'pages/WorshipPage.dart';
import 'login/Authentication.dart';
// import 'package:fancy_bar/fancy_bar.dart';
import 'package:fancy_bottom_bar/fancy_bottom_bar.dart';
import 'package:fancy_bottom_bar/fancy_bottom_item.dart';
import 'package:fancy_bottom_bar/tap_ring.dart';

class MainScreen extends StatefulWidget {
  MainScreen({
    this.auth,
    this.onSignedOut,
  });
  final AuthImplementaion auth;
  final VoidCallback onSignedOut;
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  PageController _pageController;
  int _page = 0;

  @override
  Widget build(BuildContext context) {
    precacheImage(AssetImage("images/bible.png"), context);
    precacheImage(AssetImage("images/qt.png"), context);
    return Scaffold(
      body: PageView(
        physics: NeverScrollableScrollPhysics(),
        controller: _pageController,
        onPageChanged: onPageChanged,
        children: <Widget>[
          WorshipPage(),
          QTPage(),
          HomePage(),
          // ProfilePage(),
        ],
      ),
      bottomNavigationBar:
        FancyBottomBar(
          
        // type: FancyType.FancyV2,   // Fancy Bar Type
        // selectedIndex: 2,
        items: [
          FancyBottomItem(
            // textColor: Theme.of(context).accentColor,
            title: Text("예배", style: TextStyle(
            fontFamily: 'poetAndMe',
            color: Theme.of(context).accentColor
            ),),
            icon: new Image.asset("images/bible.png", width: 30,),
          ),
          FancyBottomItem(
            // textColor: Theme.of(context).accentColor,
            title: Text("큐티", style: TextStyle(
            fontFamily: 'poetAndMe',
            // color: Theme.of(context).accentColor
            ),),
            icon: new Image.asset("images/qt.png", width: 30,),
          ),
          FancyBottomItem(
            // textColor: Theme.of(context).accentColor,
            title: Text("사진", style: TextStyle(
            fontFamily: 'poetAndMe',
            color: Theme.of(context).accentColor
            ),),
            icon: Icon(Icons.photo_camera),
          ),
          // FancyItem(
          //   textColor: Theme.of(context).accentColor,
          //   title: '제작중',
          //   icon: Icon(Joyicon.prey_clicked),
          // ),
        ],
        onItemSelected: (index) {
          navigationTapped(index);
          _page=index;
          // print(index);
        },
        selectedPosition: _page,
      ),
    );
  }

  void navigationTapped(int page) {
    _pageController.jumpToPage(page);
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  void onPageChanged(int page) {
    setState(() {
      this._page = page;
    });
  }
}
