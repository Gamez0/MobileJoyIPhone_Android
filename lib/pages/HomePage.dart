import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobilejoy/login/Authentication.dart';
import 'package:mobilejoy/joyicon_icons.dart';
import 'package:mobilejoy/pages/QTPage.dart';
import 'package:mobilejoy/pages/WorshipPage.dart';
import '../login/Authentication.dart';
import '../upload/PhotoUpload.dart';
import '../Posts/Posts.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
class HomePage extends StatefulWidget{
  HomePage({
    this.auth,
    this.onSignedOut,
  });
  final AuthImplementaion auth;
  final VoidCallback onSignedOut;
  
  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage>{
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

        postsList.insert(0,posts);
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
        centerTitle: true,
        title: new Text(
          "JOY 사진",
          style: TextStyle(
            fontFamily: 'poetAndMe',
            color: Colors.white
            ),
          ),
        backgroundColor: Theme.of(context).accentColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(30),
          ),
        ),
      ),

      body: new Container(
        child: postsList.length == 0? new Center(child: SpinKitRing(color: Theme.of(context).accentColor, size: 50,),) : new ListView.builder(
          itemCount: postsList.length,
          itemBuilder: (_, index){
            return PostsUI(postsList[index].image,postsList[index].description,postsList[index].date,postsList[index].time,);
          },
        ),
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
                      return new UploadPhotoPage();
                    })
                  );
                },
      ),
    );
  }

  Widget PostsUI(String image, String description, String date, String time){
    return new Card(
      elevation: 10.0,
      margin: EdgeInsets.all(15.0),

      child: new Container(
        // padding: new EdgeInsets.only(right:14.0),

        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: <Widget>[
            new Image.network(
              image,
              // height: 170,
              height: MediaQuery.of(context).size.height/2.7,
              width: MediaQuery.of(context).size.width,
              fit:BoxFit.cover,
            ),

            SizedBox(height: 10.0,),
            new Container(
              padding: EdgeInsets.fromLTRB(10.0,0,10.0,0),
              child: new Row(
              
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                  new Text(
                    description,
                    style: Theme.of(context).textTheme.subhead,
                    textAlign: TextAlign.center,
                  ),
              ],
            ),
            ),
            new Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                  new Text(
                    date,
                    style: Theme.of(context).textTheme.overline,
                    textAlign: TextAlign.center,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
    
  }
}