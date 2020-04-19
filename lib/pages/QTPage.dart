import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobilejoy/QTTab/qtBiblePage.dart';
import 'package:mobilejoy/QTTab/qtSharingPage.dart';
import 'package:mobilejoy/login/Authentication.dart';
import 'package:mobilejoy/joyicon_icons.dart';
import 'package:mobilejoy/pages/HomePage.dart';
import 'package:mobilejoy/pages/WorshipPage.dart';
import 'package:mobilejoy/upload/QTUpload.dart';
import '../login/Authentication.dart';

import 'package:mobilejoy/Posts/QTPosts.dart';
class QTPage extends StatefulWidget{
  QTPage({
    this.auth,
    this.onSignedOut,
  });
  final AuthImplementaion auth;
  final VoidCallback onSignedOut;
  

  @override
  State<StatefulWidget> createState() {
    return _QTPageState();
  }
}

class _QTPageState extends State<QTPage> with SingleTickerProviderStateMixin{
  List<QTPosts> postsList = [];
  TabController _tabController;
  
  @override
  void initState() {
    super.initState();
    _tabController = new TabController(vsync: this, initialIndex: 0,length: 2);
    _tabController.addListener(_handleTabSelection);
    DatabaseReference postsRef = FirebaseDatabase.instance.reference().child("QTPosts");

    postsRef.once().then((DataSnapshot snap){
      var KEYS = snap.value.keys;
      var DATA = snap.value;

      postsList.clear();

      for(var individualKey in KEYS){
        QTPosts posts = new QTPosts(
          DATA[individualKey]['author'],
          DATA[individualKey]['bible'],
          DATA[individualKey]['description'],
          DATA[individualKey]['date'],
          DATA[individualKey]['time'],
        );

        postsList.add(posts);
      }

      setState(() {
        print('Length: $postsList.length');
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
  void _handleTabSelection(){
    setState(() {
      //여기서 opacity 값 조정

    });
  }
  void _logoutUser() async{
    try{
      await widget.auth.SignOut();
      widget.onSignedOut();
    } catch(e){
      print(e.toString());
    }
  }
  @override
  Widget build(BuildContext context) {
    precacheImage(AssetImage("images/bible.png"), context);
    precacheImage(AssetImage("images/qt_clicked.png"), context);
    return new Scaffold(
      appBar: new AppBar(
        centerTitle: true,
        title: new Text(
          "QT",
          style: TextStyle(
            fontFamily: 'poetAndMe',
            // color: Theme.of(context).accentColor
            ),
          ),
        // backgroundColor: Theme.of(context).accentColor,  
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(30),
          ),
        ),
        bottom: TabBar(
          
          controller: _tabController,
          indicatorColor: Theme.of(context).accentColor,
          labelColor: Theme.of(context).accentColor,
          unselectedLabelColor: Theme.of(context).textTheme.caption.color,
          isScrollable: false,
          
          
          tabs: <Tab>[
            Tab(
              text: "본문",
              icon: new Image.asset(_tabController.index==0?"images/bible_clicked.png":"images/bible.png", width: 25,color: _tabController.index==0? Theme.of(context).accentColor:Colors.black,),
            ),
            Tab(
              text: "나눔",
              icon: new Image.asset(_tabController.index==1?"images/qt_clicked.png":"images/qt.png", width: 25,color: _tabController.index==1? Theme.of(context).accentColor:Colors.black,),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        physics: NeverScrollableScrollPhysics(),
        children: <Widget>[
          new qtBiblePage(),
          new qtSharingPage(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        // post 추가하려면 여기서
        onPressed: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context){ 
                      return new UploadQTPage();
                    })
                  );
                },
                
      ),
    );
  }

  Widget PostsUI(String author, String bible, String description, String date, String time){
    return new Card(
      // elevation: 10.0,
      margin: EdgeInsets.all(15.0),

      child: new Container(
        padding: new EdgeInsets.all(14.0),

        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: <Widget>[
            new Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                  new Text(
                  date,
                  style: Theme.of(context).textTheme.subtitle,
                  textAlign: TextAlign.center,
                ),
                new Text(
                  time,
                  style: Theme.of(context).textTheme.subtitle,
                  textAlign: TextAlign.center,
                )
              ],
            ),
            SizedBox(height: 10.0,),
            new Text(
                description,
                style: Theme.of(context).textTheme.subhead,
                textAlign: TextAlign.left,
                ),
            SizedBox(height: 10.0,),    
            new Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                  new Text(
                  bible,
                  style: Theme.of(context).textTheme.subtitle,
                  textAlign: TextAlign.center,
                ),
                
                new Text(
                  author,
                  style: Theme.of(context).textTheme.subtitle,
                  textAlign: TextAlign.center,
                )
              ],
            ),
            
          ],
        ),
      ),
    );
  }
}