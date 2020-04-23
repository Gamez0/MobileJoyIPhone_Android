import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:mobilejoy/Posts/HymnPost.dart';
import 'package:mobilejoy/Posts/BiblePost.dart';
import 'package:mobilejoy/Posts/PrayerPost.dart';
import 'package:mobilejoy/Posts/MessagePost.dart';
import 'package:mobilejoy/joyicon_icons.dart';
import 'package:mobilejoy/login/Authentication.dart';
import 'package:mobilejoy/upload/WorshipUpload.dart';
import '../login/Authentication.dart';
import 'package:flutter_point_tab_bar/pointTabBar.dart';
import 'package:flutter_point_tab_bar/pointTabIndicator.dart';

class WorshipPage extends StatefulWidget{
  WorshipPage({
    this.auth,
    this.onSignedOut,
  });
  final AuthImplementaion auth;
  final VoidCallback onSignedOut;

  @override
  State<StatefulWidget> createState() {
    return _WorshipPageState();
  }
}

class _WorshipPageState extends State<WorshipPage> with SingleTickerProviderStateMixin{
  bool guitar_visible = false;
  bool pray_visible = false;
  bool bible_visible = false;
  bool sermon_visible = false;
  // Icondata _guitar = Image.asset("images/guitar_clicked.png", width: 25,);

  final List<String> _dropdownValues = [
    "1주차","2주차","3주차","4주차",
    "5주차","6주차","7주차","8주차",
    "9주차","10주차","11주차","12주차",
    "13주차","14주차","15주차","16주차",
  ]; //The list of values we want on the dropdown
  String _currentlySelected = "1주차"; //var to hold currently selected value
  List<HymnPosts> hymnpostsList = [];
  List<PrayerPosts> praypostsList = [];
  List<BiblePosts> biblepostsList = [];
  List<MessagePosts> messagepostsList = [];

  List<HymnPosts> thisWeekhymnpostsList = [];
  List<PrayerPosts> thisWeekpraypostsList = [];
  List<BiblePosts> thisWeekbiblepostsList = [];
  List<MessagePosts> thisWeekmessagepostsList = [];
  
  




  TabController _tabController;
  //make the drop down its own widget for readability
  
  Widget notification(){
    return Center(
      child: Text("죠이어들의 편의성을 위해 기록은\n누구나 작성할 수  있습니다\n기록의 보안과 안정성을 위해\n수정과 삭제를 용이하지 않게 했습니다\n피치 못할 수정과 삭제는 아래 개발자에게 요청해주세요\ndobinshin@gmail.com", textAlign: TextAlign.center,),
    );
  }

  Widget hymnTab() {
    // setState(() {
    //   guitar_visible=true;
    //   pray_visible = false;
    //   bible_visible = false;
    //   sermon_visible = false;
    // });
    bool isEmpty=false;
    bool writePrint=false;
    return Container(
        child: new Container(
          child: (thisWeekhymnpostsList.length == 0) ? new Center(child: Text(_currentlySelected+" 찬양을 써주세요!")) : new ListView.builder(
          itemCount: thisWeekhymnpostsList.length,
          itemBuilder: (_, index){
            if(thisWeekhymnpostsList.length !=0){
              return PostsUI(thisWeekhymnpostsList[index].title,thisWeekhymnpostsList[index].description,thisWeekhymnpostsList[index].date,thisWeekhymnpostsList[index].week,true);
              }        
            }, 
          ),
        ), 
      );
  }
  Widget prayTab(){
    // setState(() {
    //   guitar_visible=false;
    //   pray_visible = true;
    //   bible_visible = false;
    //   sermon_visible = false;
    // });
    bool isEmpty=false;
    bool writePrint=false;
    return Container(
        child: new Container(
          child: (thisWeekpraypostsList.length == 0) ? new Center(child: Text(_currentlySelected+" 기도를 써주세요!")) : new ListView.builder(
          itemCount: thisWeekpraypostsList.length,
          itemBuilder: (_, index){
            if(thisWeekpraypostsList.length !=0){
                return PostsUI(thisWeekpraypostsList[index].title,thisWeekpraypostsList[index].description,thisWeekpraypostsList[index].date,thisWeekpraypostsList[index].week,false);
              }        
            }, 
          ),
        ), 
      );
  }
  Widget bibleTab(){
    // setState(() {
    //   guitar_visible=false;
    //   pray_visible = false;
    //   bible_visible = true;
    //   sermon_visible = false;
    // });
    bool isEmpty=false;
    bool writePrint=false;
    return Container(
        child: new Container(
          child: (thisWeekbiblepostsList.length == 0) ? new Center(child: Text(_currentlySelected+" 본문을 써주세요!")) : new ListView.builder(
          itemCount: thisWeekbiblepostsList.length,
          itemBuilder: (_, index){
            if(thisWeekbiblepostsList.length !=0){
              return messagePostsUI(thisWeekbiblepostsList[index].title,thisWeekbiblepostsList[index].description,thisWeekbiblepostsList[index].date,thisWeekbiblepostsList[index].week,true);
              }        
            }, 
          ),
        ), 
      );
  }
  Widget messageTab(){
    // setState(() {
    //   guitar_visible=false;
    //   pray_visible = false;
    //   bible_visible = false;
    //   sermon_visible = true;
    // });
    bool isEmpty=false;
    bool writePrint=false;
    return Container(
        child: new Container(
          child: (thisWeekmessagepostsList.length == 0) ? new Center(child: Text(_currentlySelected+" 메시지를 써주세요!")) : new ListView.builder(
          itemCount: thisWeekmessagepostsList.length,
          itemBuilder: (_, index){
            if(thisWeekmessagepostsList.length !=0){
              return messagePostsUI(thisWeekmessagepostsList[index].title,thisWeekmessagepostsList[index].description,thisWeekmessagepostsList[index].date,thisWeekmessagepostsList[index].week,false);
              }         
            }, 
          ),
        ), 
      );
  }
  Widget dropdownWidget() {
    return DropdownButton(
      //map each value from the lIst to our dropdownMenuItem widget
      icon: Icon(Icons.arrow_downward),
      iconSize: 24,
      items: _dropdownValues
          .map((value) => DropdownMenuItem(
                child: Text(value),
                value: value,
              ))
          .toList(),
      onChanged: (String value) {
        
        // 그 주차의 정보들을 불러오기
        //once dropdown changes, update the state of out currentValue
        setState(() {
          _currentlySelected = value;
          getWeek();
        });
      },
      //this wont make dropdown expanded and fill the horizontal space
      isExpanded: false,
      //make default value of dropdown the first value of our list
      // value: _dropdownValues.first,
      value: _currentlySelected,
    );
  }
  
  @override
  void initState() {
    // _dropdownMenuItems = buildDropdownMenuItems(_week);
    // _selectedWeek = _dropdownMenuItems[0].value;
    super.initState();
    _tabController = new TabController(vsync: this, initialIndex: 0,length: 5);
    _tabController.addListener(_handleTabSelection);
    DatabaseReference hymnpostsRef = FirebaseDatabase.instance.reference().child("hymnPosts");
    DatabaseReference praypostsRef = FirebaseDatabase.instance.reference().child("prayPosts");
    DatabaseReference biblepostsRef = FirebaseDatabase.instance.reference().child("biblePosts");
    DatabaseReference messagepostsRef = FirebaseDatabase.instance.reference().child("messagePosts");
    // 찬양 data 불러오기
    hymnpostsRef.once().then((DataSnapshot snap){
      var KEYS = snap.value.keys;
      var DATA = snap.value;

      hymnpostsList.clear();
      for(var individualKey in KEYS){
        HymnPosts posts = new HymnPosts(
          DATA[individualKey]['title'],
          DATA[individualKey]['description'],
          DATA[individualKey]['date'],
          DATA[individualKey]['week'],
        );
        hymnpostsList.add(posts);
      }
      setState(() {
        print('Length: $hymnpostsList.length');
      });
    });
    // 기도 불러오기
    praypostsRef.once().then((DataSnapshot snap){
      var KEYS = snap.value.keys;
      var DATA = snap.value;

      praypostsList.clear();
      for(var individualKey in KEYS){
        PrayerPosts posts = new PrayerPosts(
          DATA[individualKey]['title'],
          DATA[individualKey]['description'],
          DATA[individualKey]['date'],
          DATA[individualKey]['week'],
        );
        praypostsList.add(posts);
      }
      setState(() {
        print('Length: $praypostsList.length');
      });
    });
    // 성경 불러오기
    biblepostsRef.once().then((DataSnapshot snap){
      var KEYS = snap.value.keys;
      var DATA = snap.value;

      biblepostsList.clear();
      for(var individualKey in KEYS){
        BiblePosts posts = new BiblePosts(
          DATA[individualKey]['title'],
          DATA[individualKey]['description'],
          DATA[individualKey]['date'],
          DATA[individualKey]['week'],
        );
        biblepostsList.add(posts);
      }
      setState(() {
        print('Length: $biblepostsList.length');
      });
    });
    // 메시지 불러오기
    messagepostsRef.once().then((DataSnapshot snap){
      var KEYS = snap.value.keys;
      var DATA = snap.value;

      messagepostsList.clear();
      for(var individualKey in KEYS){
        MessagePosts posts = new MessagePosts(
          DATA[individualKey]['title'],
          DATA[individualKey]['description'],
          DATA[individualKey]['date'],
          DATA[individualKey]['week'],
        );
        messagepostsList.add(posts);
      }
      setState(() {
        print('Length: $messagepostsList.length');
      });
    });
    // getWeek();
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
    getWeek();
    precacheImage(AssetImage("images/guitar.png"), context);
    precacheImage(AssetImage("images/guitar_clicked.png"), context);
    precacheImage(AssetImage("images/pray.png"), context);
    precacheImage(AssetImage("images/pray_clicked.png"), context);
    precacheImage(AssetImage("images/bible.png"), context);
    precacheImage(AssetImage("images/bible_clicked.png"), context);
    precacheImage(AssetImage("images/sermon.png"), context);
    precacheImage(AssetImage("images/sermon_clicked.png"), context);

    ImageProvider guitar_clicked2 = AssetImage("images/guitar_clicked.png");
    ImageProvider pray_clicked2 = AssetImage("images/pray_clicked.png");
    ImageProvider bible_clicked2 = AssetImage("images/bible_clicked.png");
    ImageProvider sermon_clicked2 = AssetImage("images/sermon_clicked.png");

    ImageIcon guitar_clicked = ImageIcon(AssetImage("images/guitar_clicked.png"), color: Theme.of(context).accentColor,);
    ImageIcon pray_clicked = ImageIcon(AssetImage("images/pray_clicked.png"), color: Theme.of(context).accentColor,);
    ImageIcon bible_clicked = ImageIcon(AssetImage("images/bible_clicked.png"), color: Theme.of(context).accentColor,);
    ImageIcon sermon_clicked = ImageIcon(AssetImage("images/sermon_clicked.png"), color: Theme.of(context).accentColor,);
    return new Scaffold(
      appBar: new AppBar(
        centerTitle: true,
        // backgroundColor: Theme.of(context).accentColor,
        title: new Text(
          "JOY 예배",
          style: TextStyle(
            fontFamily: 'poetAndMe',
            // color: Theme.of(context).accentColor
            ),
            
          ),
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
          indicator: PointTabIndicator(
            position: PointTabIndicatorPosition.bottom,
            color: Theme.of(context).accentColor,
            insets: EdgeInsets.only(bottom: 6),
          ),
          tabs: <Tab>[
            Tab(
              text: "찬양",
              // icon: guitar_clicked,
              // icon : ImageIcon(guitar_clicked2, color: Theme.of(context).accentColor,)
              // icon: new Image.asset("images/guitar_clicked.png", width: 25,),
              icon: new Image.asset(_tabController.index==0?"images/guitar_clicked.png":"images/guitar.png", width: 25, color: _tabController.index==0? Theme.of(context).accentColor:Colors.black,),
              // icon: new Icon(Joyicon.hymn),
              // icon: AnimatedOpacity(
              //   opacity: guitar_visible? 1.0:0.0,
              //   duration: Duration(milliseconds: 500),
              //   child:new Image.asset("images/guitar.png", width: 25,),
              //   ),
              // child :AnimatedOpacity(
              //   opacity: guitar_visible? 0.0:1.0,
              //   duration: Duration(milliseconds: 500),
              //   child: new Image.asset("images/guitar_clicked.png", width: 25,),
              //   ),
            ),
            Tab(
              text: "기도문",
              // icon : pray_clicked,
              // icon : ImageIcon(AssetImage("images/pray_clicked.png"), color: Theme.of(context).accentColor,)
              // icon: new Image.asset("images/pray_clicked.png", width: 25,),
              icon: new Image.asset(_tabController.index==1?"images/pray_clicked.png":"images/pray.png", width: 25,color: _tabController.index==1? Theme.of(context).accentColor:Colors.black,),
            ),
            Tab(
              text: "말씀",
              // icon : bible_clicked,
              // icon : ImageIcon(AssetImage("images/bible_clicked.png"), color: Theme.of(context).accentColor,)
              // icon: new Image.asset("images/bible_clicked.png", width: 25,),
              icon: new Image.asset(_tabController.index==2?"images/bible_clicked.png":"images/bible.png", width: 25,color: _tabController.index==2? Theme.of(context).accentColor:Colors.black,),
            ),
            Tab(
              text: "메시지",
              // icon : sermon_clicked,
              // icon : ImageIcon(AssetImage("images/sermon_clicked.png"), color: Theme.of(context).accentColor,)
              // icon: new Image.asset("images/sermon_clicked.png", width: 25,),
              icon: new Image.asset(_tabController.index==3?"images/sermon_clicked.png":"images/sermon.png", width: 25,color: _tabController.index==3? Theme.of(context).accentColor:Colors.black,),
            ),
            Tab(
              // text:"주차",
              child: dropdownWidget(),
              
              ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: <Widget>[
          hymnTab(),
          prayTab(),
          bibleTab(),
          messageTab(),
          notification(),
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
                      return new UploadWorshipPage();
                    })
                  );
                },
      ),
    );
  }

  Widget PostsUI(String title, String description, String date, String week, bool hymn){
    return new Card(
      // elevation: 10.0,
      margin: EdgeInsets.all(15.0),

      child: new Container(
        padding: new EdgeInsets.all(14.0),

        child: new Column(
          // crossAxisAlignment: CrossAxisAlignment.start,

          children: <Widget>[
            new Text(//제목
                  title,
                  style: hymn? Theme.of(context).textTheme.title:Theme.of(context).textTheme.subhead,
                  textAlign: TextAlign.center,
                  
                ),

            SizedBox(height: 10.0,),
            new Text(//내용
                  description,
                  style: Theme.of(context).textTheme.subhead,
                  textAlign: TextAlign.start,
                ),
            SizedBox(height: 10.0,), 
            new Row(
              mainAxisAlignment: MainAxisAlignment.end,
              // crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                  // new Text(//Apr 10, 2020
                  //   date,
                  //   style: Theme.of(context).textTheme.subtitle,
                  //   textAlign: TextAlign.center,
                  // ),
                
                  new Text(//1주차
                    week+" "+date,
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
  Widget messagePostsUI(String title, String description, String date, String week, bool bible){
    return new Card(
      // elevation: 10.0,
      margin: EdgeInsets.all(15.0),

      child: new Container(
        padding: new EdgeInsets.all(14.0),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.black,width: 2.0)
          )
        ),
        child: new Column(
          // crossAxisAlignment: CrossAxisAlignment.start,
          
          children: <Widget>[
            new Text(//제목
                  bible? title:"메신저 "+title,
                  style: Theme.of(context).textTheme.subhead,
                  textAlign: TextAlign.center,

                ),

            SizedBox(height: 15.0,),
            
            new Text(//내용
                  description,
                  style: Theme.of(context).textTheme.subhead,
                  textAlign: TextAlign.start,
                ),
            SizedBox(height: 10.0,), 
            new Row(
              mainAxisAlignment: MainAxisAlignment.end,
              // crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                  // new Text(//Apr 10, 2020
                  //   date,
                  //   style: Theme.of(context).textTheme.subtitle,
                  //   textAlign: TextAlign.center,
                  // ),
                
                  new Text(//1주차
                    week+" "+date,
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

  void getWeek(){
    thisWeekpraypostsList.clear();
    thisWeekbiblepostsList.clear();
    thisWeekhymnpostsList.clear();
    thisWeekmessagepostsList.clear();
    
    for(int i=0;i<hymnpostsList.length;i++){
      if(hymnpostsList[i].week==_currentlySelected){
        thisWeekhymnpostsList.add(hymnpostsList[i]);
      }
    }
    for(int i=0;i<praypostsList.length;i++){
      if(praypostsList[i].week==_currentlySelected){
        thisWeekpraypostsList.add(praypostsList[i]);
      }
    }
    for(int i=0;i<biblepostsList.length;i++){
      if(biblepostsList[i].week==_currentlySelected){
        thisWeekbiblepostsList.add(biblepostsList[i]);
      }
    }
    for(int i=0;i<messagepostsList.length;i++){
      if(messagepostsList[i].week==_currentlySelected){
        thisWeekmessagepostsList.add(messagepostsList[i]);
      }
    }
  }
  int numWeek(String week){
    int num=0;
    num = int.parse(week[0])-1;
    return num;
  }
  bool isWeek(){
    for(int index=0;index<16;index++){
      if(hymnpostsList[index].week==_currentlySelected){
        return true;
      }
      if(biblepostsList[index].week==_currentlySelected){
        return true;
      }
      if(praypostsList[index].week==_currentlySelected){
        return true;
      }
      if(messagepostsList[index].week==_currentlySelected){
        return true;
      }
    }
    return false;
  }
  
}