import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobilejoy/pages/QTPage.dart';
import 'dart:io';
import '../pages/HomePage.dart';

import 'package:mobilejoy/pages/HomePage.dart';

class UploadQTPage extends StatefulWidget{
  State<StatefulWidget> createState(){
    return _UploadQTPageState();
  }
}

class _UploadQTPageState extends State<UploadQTPage>{
  // File sampleImage;
  String _myName;
  String _myBible;
  String _myValue;
  String url;
  final formKey = new GlobalKey<FormState>();

  // Future getImage() async{
  //   var tempImage = await ImagePicker.pickImage(source: ImageSource.gallery);

  //   setState(() {
  //     sampleImage = tempImage;
  //   });
  // }

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
      final StorageReference postImageRef = FirebaseStorage.instance.ref().child("Post Images");

      var timeKey = new DateTime.now();

      // final StorageUploadTask uploadTask = postImageRef.child(timeKey.toString()+".jpg").putFile(sampleImage);

      // var ImageUrl = await(await uploadTask.onComplete).ref.getDownloadURL();

      // url = ImageUrl.toString();

      // print("Image url = "+url);

      goToQTPage();
      saveToDatabase();
    }
  }

  void saveToDatabase(){
    var dbTimeKey = new DateTime.now();
    var formatDate = new DateFormat('MMM d, yyyy');
    var formatTime = new DateFormat('EEEE, hh:mm:aaa');

    String date = formatDate.format(dbTimeKey);
    String time = formatTime.format(dbTimeKey);

    DatabaseReference ref = FirebaseDatabase.instance.reference();

    var data = {
      "author": _myName,
      "bible": _myBible,
      "description": _myValue,
      "date": date,
      "time": time,
    };

    ref.child("QTPosts").push().set(data);
  }

  void goToQTPage(){
    Navigator.push(
      context, 
      MaterialPageRoute(builder: (context){
        return new QTPage();
      },maintainState: false)
      );
  }
  OutlineInputBorder _outlineBorder = OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(24)),
    borderSide: BorderSide(
      style: BorderStyle.solid,
    ),
  );
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("QT 나눔 작성"),
        centerTitle: true,
      ),
      body: new Center(
        child: enableUpload(),
      ),
     );
  }
  Widget enableUpload(){
    return Container(
      child: new Form(
        key: formKey,
          child:ListView(
            children: <Widget>[
              new Row(
                children: <Widget>[
                  Text("작성자", style: TextStyle(fontWeight: FontWeight.bold),),
                  new Flexible(
                      child: new TextFormField(
                        decoration: new InputDecoration(
                          labelText: 'ex. 죠이어1',
                          contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                          border: _outlineBorder,
                          enabledBorder: _outlineBorder,
                          focusedBorder: _outlineBorder,
                        ),
                        validator: (value){
                          return value.isEmpty ? '작성자를 써주세요' : null;
                        },
                        onSaved: (value){
                          return _myName = value;
                        },
                      ),
                    ),
                ],
              ),
              SizedBox(height: 15.0,),
              new Row(
                children: <Widget>[
                  Text("말씀", style: TextStyle(fontWeight: FontWeight.bold),),
                  new Flexible(
                      child: new TextFormField(
                        decoration: new InputDecoration(
                          labelText: 'ex. 막1:1',
                          contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                          border: _outlineBorder,
                          enabledBorder: _outlineBorder,
                          focusedBorder: _outlineBorder,
                        ),
                        validator: (value){
                          return value.isEmpty ? '어디 말씀인지 써주세요' : null;
                        },
                        onSaved: (value){
                          return _myBible = value;
                        },
                      ),
                    ),
                ],
              ),
              
              SizedBox(height: 15.0,),
              Text("나눔", style: TextStyle(fontWeight: FontWeight.bold),),
              SizedBox(
                height: 300.0,
                child: new TextFormField(
                      decoration: new InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                        border: _outlineBorder,
                        enabledBorder: _outlineBorder,
                        focusedBorder: _outlineBorder,
                        // labelText: '...',
                      ),
                      keyboardType: TextInputType.multiline,
                      maxLines: 10,
                      validator: (value){
                        return value.isEmpty ? '나눔을 써주세요' : null;
                      },
                      onSaved: (value){
                        return _myValue = value;
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
              ),
              
            ],
          ),
      ),
    );
  }
}