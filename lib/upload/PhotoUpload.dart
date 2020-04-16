import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../pages/HomePage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mobilejoy/pages/HomePage.dart';

class UploadPhotoPage extends StatefulWidget{
  State<StatefulWidget> createState(){
    return _UploadPhotoPageState();
  }
}

class _UploadPhotoPageState extends State<UploadPhotoPage>{
  final scaffoldKey = GlobalKey<ScaffoldState>();
  File sampleImage;
  String _myValue;
  String url;
  final formKey = new GlobalKey<FormState>();
  final reqPhotoSnackBar = SnackBar(
                  content: Text('사진을 필수입니다'),
                  action: SnackBarAction(
                    label: 'Undo',
                    onPressed: () {
                  // Some code to undo the change.
                  },
                ),
          );

  Future getImage() async{
    var tempImage = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      sampleImage = tempImage;
    });
  }

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

      final StorageUploadTask uploadTask = postImageRef.child(timeKey.toString()+".jpg").putFile(sampleImage);

      var ImageUrl = await(await uploadTask.onComplete).ref.getDownloadURL();

      url = ImageUrl.toString();

      print("Image url = "+url);

      goToHomePage();
      saveToDatabase(url);
    }
  }

  void saveToDatabase(url){
    var dbTimeKey = new DateTime.now();
    var formatDate = new DateFormat('MMM d, yyyy');
    var formatTime = new DateFormat('EEEE, hh:mm:aaa');

    String date = formatDate.format(dbTimeKey);
    String time = formatTime.format(dbTimeKey);

    DatabaseReference ref = FirebaseDatabase.instance.reference();

    var data = {
      "image":url,
      "description": _myValue,
      "date": date,
      "time": time,
    };

    ref.child("Posts").push().set(data);
  }

  void goToHomePage(){
    Navigator.push(
      context, 
      MaterialPageRoute(builder: (context){
        return new HomePage();
      })
      );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      key: scaffoldKey,
      appBar: new AppBar(
        centerTitle: true,
        backgroundColor: Theme.of(context).accentColor,
        title: new Text(
          "사진 업로드",
          style: TextStyle(
            fontFamily: 'poetAndMe',
            color: Colors.white
            ),
          ),
      
      ),
      body:
      new Center(
        // child: sampleImage == null? Text("이미지 업로드"): enableUpload(),
        child: enableUpload(),
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: getImage,
        tooltip: 'Add Image',
        child: new Icon(Icons.add_a_photo),
        ),
      );
  }
  Widget enableUpload(){
    return Container(
      child: new Form(
        key: formKey,
          child:Column(
            children: <Widget>[
              SizedBox(height: 15.0,),
              sampleImage == null ? SizedBox(
                
                height: 100,
                width: 100,
                child: RaisedButton(
                
                elevation: 10.0,
                child: Center(
                  
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(Icons.add),
                      Text("사진"),
                    ],
                  ),
                ),
                textColor: Colors.black,
                // color: Colors.,
                onPressed: getImage,
                
              )): Image.file(sampleImage, height: 330.0, width: 600.0,),

              SizedBox(height: 15.0,),

              TextFormField(
                decoration: new InputDecoration(labelText: '죠이에서 무슨 일이 있나요?'),

                validator: (value){
                  return value.isEmpty ? value=null : null;
                },

                onSaved: (value){
                  return _myValue = value;
                },
              ),

              SizedBox(height: 15.0,),

              RaisedButton(
                  elevation: 10.0,
                  child: Text("은혜 나누기"),
                  textColor: Colors.white,
                  color: Theme.of(context).accentColor,

                  onPressed: sampleImage==null?
                  getImage:uploadStatusImage,
                  //scaffoldKey.currentState.showSnackBar(SnackBar(content: Text("사진을 필수입니다."),))
                ),
              
              
            ],
          ),
      ),
    );
  }
  
}