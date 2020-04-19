import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobilejoy/QTTab/qtBiblePage.dart';
import 'package:mobilejoy/QTTab/qtSharingPage.dart';
import 'package:mobilejoy/login/Authentication.dart';
import 'package:mobilejoy/joyicon_icons.dart';
import 'package:mobilejoy/upload/QTUpload.dart';
import '../login/Authentication.dart';
import 'package:mobilejoy/Posts/QTPosts.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class qtSharingPage extends StatefulWidget{
  qtSharingPage({
    this.auth,
    this.onSignedOut,
  });
  final AuthImplementaion auth;
  final VoidCallback onSignedOut;
  

  @override
  State<StatefulWidget> createState() {
    return _qtSharingPage();
  }
}

class _qtSharingPage extends State<qtSharingPage>{
  List<QTPosts> postsList = [];
  TabController _tabController;
  
  @override
  void initState() {
    super.initState();
    

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

        postsList.insert(0, posts);
      }

      setState(() {
        print('Length: $postsList.length');
      });
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
    return new Scaffold(
      body: new Container(
        child: postsList.length == 0? new Center(child: SpinKitRing(color: Theme.of(context).accentColor, size: 50,),) : new ListView.builder(
          itemCount: postsList.length,
          itemBuilder: (_, index){
            return PostsUI(postsList[index].author,postsList[index].bible,postsList[index].description,postsList[index].date,postsList[index].time,);
          },
        ),
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
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            new Text(
                  bible,
                  style: Theme.of(context).textTheme.title,
                  textAlign: TextAlign.center,
                  
                ),
            SizedBox(height: 10.0,),
            new Text(
                description,
                style: Theme.of(context).textTheme.subhead,
                textAlign: TextAlign.start,
                ),
            SizedBox(height: 10.0,),
            new Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                  new Text(
                  date,
                  style: Theme.of(context).textTheme.overline,
                  textAlign: TextAlign.center,
                ),
                new Text(
                  author,
                  style: Theme.of(context).textTheme.overline,
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