import 'package:flutter/material.dart'; 
import 'package:firebase_database/firebase_database.dart';
import 'package:mobilejoy/Posts/HymnPost.dart';

class HymnPage extends StatelessWidget { 
  
  List<HymnPosts> postsList = [];
  @override 
  Widget build(BuildContext context) {
     return Container(
        child: new Center(
           child: new Text("찬양을 써주세요."),
        ), 
      ); 
  } 
}
