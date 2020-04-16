import 'package:flutter/material.dart';
import 'package:mobilejoy/joyicon_icons.dart';
import 'pages/HomePage.dart';
import 'pages/ProfilePage.dart';
import 'pages/QTPage.dart';
import 'pages/WorshipPage.dart';
import 'login/Authentication.dart';
import 'package:fancy_bar/fancy_bar.dart';

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
        type: FancyType.FancyV2,   // Fancy Bar Type
        selectedIndex: 2,
        items: [
          FancyItem(
            textColor: Theme.of(context).accentColor,
            title: '예배',
            icon: Icon(Joyicon.bible),
          ),
          FancyItem(
            textColor: Theme.of(context).accentColor,
            title: '큐티',
            icon: Icon(Joyicon.qt,),
          ),
          FancyItem(
            textColor: Theme.of(context).accentColor,
            title: '사진',
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
          // print(index);
        },
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
