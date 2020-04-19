import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:mobilejoy/login/Authentication.dart';
import 'package:mobilejoy/joyicon_icons.dart';
import 'package:mobilejoy/pages/QTPage.dart';
import 'package:mobilejoy/pages/WorshipPage.dart';
import '../login/Authentication.dart';
import '../Posts/Posts.dart';
class ProfilePage extends StatefulWidget{
  ProfilePage({
    this.auth,
    this.onSignedOut,
  });
  final AuthImplementaion auth;
  final VoidCallback onSignedOut;

  @override
  State<StatefulWidget> createState() {
    return _ProfilePageState();
  }
}

class _ProfilePageState extends State<ProfilePage>{
  PageController _pageController;
  int _page = 2;

  List<Posts> postsList = [];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 2);

    DatabaseReference postsRef = FirebaseDatabase.instance.reference().child("Posts");

    postsRef.once().then((DataSnapshot snap){
      var KEYS = snap.value.keys;
      var DATA = snap.value;

      postsList.clear();

      for(var individualKey in KEYS){
        Posts posts = new Posts(
          DATA[individualKey]['image'],
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
    super.dispose();
    _pageController.dispose();
  }
  void onPageChanged(int page) {
    setState(() {
      this._page = page;
    });
  }
  void navigationTapped(int page) {
    _pageController.jumpToPage(page);
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
      appBar: new AppBar(
        title: new Text("계정 관리"),
      ),

      body: new Container(
        child: postsList.length == 0? new Text("No Blog Post available") : new ListView.builder(
          itemCount: postsList.length,
          itemBuilder: (_, index){
            return PostsUI(postsList[index].image,postsList[index].description,postsList[index].date,postsList[index].time,);
          },
        ),
      ),
    );
  }

  Widget PostsUI(String image, String description, String date, String time){
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

            new Image.network(image, fit:BoxFit.cover),

            SizedBox(height: 10.0,),
            new Text(
                  description,
                  style: Theme.of(context).textTheme.subhead,
                  textAlign: TextAlign.center,
                )
          ],
        ),
      ),
    );
    
  }
}