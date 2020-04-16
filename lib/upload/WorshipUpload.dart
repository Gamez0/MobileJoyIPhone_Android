import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobilejoy/pages/QTPage.dart';
import 'package:mobilejoy/pages/WorshipPage.dart';
import 'dart:io';
import '../pages/HomePage.dart';
import 'package:mobilejoy/pages/HomePage.dart';

class UploadWorshipPage extends StatefulWidget{
  State<StatefulWidget> createState(){
    return _UploadWorshipPageState();
  }
}

class _UploadWorshipPageState extends State<UploadWorshipPage>{
  // File sampleImage;
  String _title;
  String _description;
  String _week;
  String url;
  String _currentlySelected = "찬양";
  String _currentlySelectedWeek = "1주차";
  final List<String> _dropdownValues = [
    "찬양","기도문","본문말씀","메시지",
  ];
  final List<String> _dropdownValuesWeek = [
    "1주차","2주차","3주차","4주차",
    "5주차","6주차","7주차","8주차",
    "9주차","10주차","11주차","12주차",
    "13주차","14주차","15주차","16주차",
  ];
  final formKey = new GlobalKey<FormState>();

  bool validateAndSave(){
    final form = formKey.currentState;

    if(form.validate()){
      form.save();
      return true;
    }else{
      return false;
    }
  }

  void uploadStatusImage() async{
    if(validateAndSave()){
      _week = _currentlySelectedWeek;
      final StorageReference postImageRef = FirebaseStorage.instance.ref().child("Post Images");

      var timeKey = new DateTime.now();

      // final StorageUploadTask uploadTask = postImageRef.child(timeKey.toString()+".jpg").putFile(sampleImage);

      // var ImageUrl = await(await uploadTask.onComplete).ref.getDownloadURL();

      // url = ImageUrl.toString();

      // print("Image url = "+url);

      goToWorshipPage();
      saveToDatabase();
    }
  }

  void saveToDatabase(){
    var dbTimeKey = new DateTime.now();
    var formatDate = new DateFormat('MMM d, yyyy');
    var formatTime = new DateFormat('EEEE, hh:mm:aaa');

    String date = formatDate.format(dbTimeKey);

    DatabaseReference ref = FirebaseDatabase.instance.reference();

    var data = {
      "title": _title,
      "description": _description,
      "date": date,
      "week": _week,
    };
    // _week=_currentlySelectedWeek;
    // 어떤 post를 업로드하냐에 따라 다르게 넣어줘야한다.
    switch(_currentlySelected){
      case "찬양":
        ref.child("hymnPosts").push().set(data);
        break;
      case "기도문":
        ref.child("prayPosts").push().set(data);
        break;
      case "본문말씀":
        ref.child("biblePosts").push().set(data);
        break;
      case "메시지":
        ref.child("messagePosts").push().set(data);
        break;
    }
    // ref.child("hymnPosts").push().set(data);
  }

  void goToWorshipPage(){
    Navigator.push(
      context, 
      MaterialPageRoute(builder: (context){
        return new WorshipPage();
      },maintainState: false)
      );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: new AppBar(
        title: new Text("예배 후기 작성"),
        centerTitle: true,
      ),
      body: new Center(
        child: enableUpload(),
      ),
     );
  }
  Widget dropdownWidget() {
    return DropdownButton(
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
        });
      },
      isExpanded: false,
      value: _currentlySelected,
    );
  }
  Widget dropdownWeekWidget() {
    return DropdownButton(
      icon: Icon(Icons.arrow_downward),
      iconSize: 24,
      items: _dropdownValuesWeek
          .map((value) => DropdownMenuItem(
                child: Text(value),
                value: value,
              ))
          .toList(),
      onChanged: (String value) {
        
        // 그 주차의 정보들을 불러오기
        //once dropdown changes, update the state of out currentValue
        setState(() {
          _currentlySelectedWeek = value;
        });
      },
      isExpanded: false,
      value: _currentlySelectedWeek,
    );
  }

  OutlineInputBorder _outlineBorder = OutlineInputBorder(
  borderRadius: BorderRadius.all(Radius.circular(24)),
  borderSide: BorderSide(
    style: BorderStyle.solid,
  ),
);

  Widget enableUpload(){
    return Container(
      
      child: new Form(
        key: formKey,
          child:ListView(
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new Row(

                children: <Widget>[
                  Text("분류", style: TextStyle(fontWeight: FontWeight.bold),),
                  dropdownWidget(),
                    
                  Text("주차", style: TextStyle(fontWeight: FontWeight.bold),),
                  dropdownWeekWidget(),
                ],
              ),
              
              SizedBox(height: 15.0,),
              new Row(
                  children: <Widget>[
                    Text("제목/담당자", style: TextStyle(fontWeight: FontWeight.bold),),
                    new Flexible(
                      child: new TextFormField(
                        decoration: new InputDecoration(
                          labelText: '찬양제목/담당자',
                          contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                          border: _outlineBorder,
                          enabledBorder: _outlineBorder,
                          focusedBorder: _outlineBorder,
                        ),
                        validator: (value){
                          return value.isEmpty ? '찬양제목/대표 기도자/메신저를 써주세요' : null;
                        },
                        onSaved: (value){
                          return _title = value;
                        },
                      ),
                    ),
                  ],
              ),
              
              SizedBox(height: 15.0,),
              Text("내용", style: TextStyle(fontWeight: FontWeight.bold),),
              SizedBox(
                height: 300.0,
                child: new TextFormField(
                      decoration: new InputDecoration(
                        // labelText: '나눔/기도문/말씀/메시지',
                        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                        border: _outlineBorder,
                        enabledBorder: _outlineBorder,
                        focusedBorder: _outlineBorder,
                        hintText: '나눔/기도문/말씀/메시지',
                      ),
                      keyboardType: TextInputType.multiline,
                      maxLines: 10,
                      validator: (value){
                        return value.isEmpty ? '내용을 써주세요' : null;
                      },
                      onSaved: (value){
                        return _description = value;
                      },
                    ),
              ),      
              SizedBox(height: 15.0,),
              Center(
                child: RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    padding: EdgeInsets.all(12),
                    color: Theme.of(context).accentColor,
                    elevation: 10.0,
                    child: Text("은혜 나누기", style: TextStyle(color: Colors.white),),
                    onPressed: uploadStatusImage,
                  ),
                )
              
            ],
          ),
      ),
    );
  }
}