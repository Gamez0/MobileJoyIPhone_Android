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
import 'package:flutter_point_tab_bar/pointTabBar.dart';
import 'package:flutter_point_tab_bar/pointTabIndicator.dart';

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
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black,
            ),
          ],
        ),
        child: 
        // BottomNavigationBar(

      //   iconSize: 10,
      //   unselectedFontSize: 18,
      //   selectedFontSize: 18,
      //   items: <BottomNavigationBarItem>[
      //     new BottomNavigationBarItem(
      //         icon: new Image.asset("images/bible.png", /*width: 0,*/),
      //         title: new Text("예배")
      //     ),
      //     new BottomNavigationBarItem(
      //         icon: new Image.asset("images/qt.png", /*width: 0,*/),
      //         title: new Text("큐티")
      //     ),
      //     new BottomNavigationBarItem(
      //         icon: new Image.asset("images/camera.png", /*width: 0,*/),
      //         title: new Text("사진")
      //     )
      //   ],
      //   currentIndex: _page,
      //   onTap: (int i){setState((){
      //     navigationTapped(i);
      //     _page = i;
      //     });},
      //   fixedColor: Colors.black,
      //   unselectedItemColor: Colors.grey[700],
      //   backgroundColor: Colors.grey[200],
      //   // backgroundColor: Colors.black45,
      // ),
      // )
      // TabBar(
      //   labelColor: Theme.of(context).accentColor,
      //   unselectedLabelColor: Theme.of(context).textTheme.caption.color,
      //   indicatorColor: Theme.of(context).accentColor,
      //   indicator: PointTabIndicator(
      //       position: PointTabIndicatorPosition.bottom,
      //       color: Theme.of(context).accentColor,
      //       insets: EdgeInsets.only(bottom: 6),
      //     ),
      //   tabs: <Tab>[
      //     Tab(
      //         text: "예배",
      //       ),
      //       Tab(
      //         text: "큐티",
      //       ),
      //       Tab(
      //         text: "사진",
      //       ),
      //   ]
      //   )
        FancyBottomBar(
          
        // type: FancyType.FancyV2,   // Fancy Bar Type
        // selectedIndex: 0,
        items: [
          FancyBottomItem(
            // textColor: Theme.of(context).accentColor,
            title: Text("예배", style: TextStyle(
            fontFamily: 'poetAndMe',
            color: Colors.black
            ),),
            // title: '예배',
            icon: new Image.asset("images/bible.png", width: 30,),
          ),
          FancyBottomItem(
            // textColor: Theme.of(context).accentColor,
            // title: '큐티',
            title: Text("큐티", style: TextStyle(
            fontFamily: 'poetAndMe',
            color: Colors.black
            ),),
            icon: new Image.asset("images/qt.png", width: 30,),
          ),
          FancyBottomItem(
            // textColor: Theme.of(context).accentColor,
            // title: '사진',
            title: Text("사진", style: TextStyle(
            fontFamily: 'poetAndMe',
            color: Colors.black
            ),),
            icon: new Image.asset("images/camera.png", width: 30,),
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
      )
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
