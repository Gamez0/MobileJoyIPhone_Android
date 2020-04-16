import 'package:flutter/material.dart';

import 'Authentication.dart';
import '../DialogBox.dart';

class LoginRegisterPage extends StatefulWidget{

  LoginRegisterPage({
    this.auth,
    this.onSignedIn,
  });
  final AuthImplementaion auth;
  final VoidCallback onSignedIn;

  State<StatefulWidget> createState(){
    return _LoginRegisterState();
  }
  
}
enum FormType
{
  login,
  register
}
class _LoginRegisterState extends State<LoginRegisterPage>{
  DialogBox dialogBox = new DialogBox();

  final formKey = new GlobalKey<FormState>();
  FormType _formType = FormType.login;
  String _email ="";
  String _password =""; 

  //methods
  bool validateAndSave()
  {
    final form = formKey.currentState;

    if(form.validate()){
      form.save();
      return true;
    }else{
      return false;
    }
  } 

  void validateAndSubmit() async{
    if(validateAndSave()){
      try{
        if(_formType == FormType.login){
          String userId = await widget.auth.SignIn(_email, _password);
          //dialogBox.information(context, "성공 ", "로그인");
          print("login userid ="+userId);
        }
        else{
          String userId = await widget.auth.SignUp(_email, _password);
          //dialogBox.information(context, "성공 ", "계정 생성");
          print("Register userid ="+userId);
        }
        widget.onSignedIn();
      } catch(e){
        dialogBox.information(context, "Error = ", e.toString());
        print("Error = "+e.toString());
      }
    }
  }

  void moveToRegister()
  {
    formKey.currentState.reset();

    setState(() {
      _formType = FormType.register;
    });
  }
  void moveToLogin()
  {
    formKey.currentState.reset();

    setState(() {
      _formType = FormType.login;
    });
  }

  //Design
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar:  new AppBar(
        // title: new Text("모바일 Joy"),
        ),

        body: new Container
        (
          margin: EdgeInsets.all(15.0),

          child: new Form
          (
            key: formKey,
            child: new Column
            (
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: createInputs() + createButtons(),
            ),
          ),
        ),
    );
  }


  List<Widget> createInputs()
  {
    return
    [
      SizedBox(height: 60.0,),
      logo(),
      SizedBox(height: 40.0,),

      new TextFormField
      (
        autofocus: false,
        // initialValue: 'example@praylist.com',
        keyboardType: TextInputType.emailAddress,
        decoration: new InputDecoration(
          hintText: 'example@praylist.com',
          contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
          ),
        
        validator: (value){
          return value.isEmpty ? '이메일은 필수입니다' :null;
        },

        onSaved: (value){
          return _email = value;
        },
      ),
      
      SizedBox(height: 10.0,),
      
      new TextFormField
      (
        autofocus: false,
        // initialValue: 'some password',
        decoration: new InputDecoration(
          hintText: 'Password',
          contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
          ),
        obscureText: true,

        validator: (value){
          return value.isEmpty ? '비밀번호는 필수입니다. 6자리 이상' :null;
        },

        onSaved: (value){
          return _password = value;
        },
      ),

      SizedBox(height: 20.0,),

    ];
  }

  Widget logo()
  {
    return new Hero
    (
      tag: 'hero',
      child: new CircleAvatar
      (
        // maxRadius: 100,
        backgroundColor: Colors.transparent,
        radius: 60.0,
        child: Image.asset('images/app_logo.png'),
        
      ),
    );
  }

  List<Widget> createButtons()
  {
    if(_formType == FormType.login){
      return
    [
      
      new RaisedButton
      (
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        padding: EdgeInsets.all(12),
        child: new Text("로그인", style: new TextStyle(fontSize: 20.0)),
        textColor: Colors.white,
        color: Theme.of(context).accentColor,
        onPressed: validateAndSubmit,
        ),
      new FlatButton
      (
        child: new Text("계정 생성", style: new TextStyle(fontSize: 20.0)),
        textColor: Theme.of(context).accentColor,
        
        onPressed: moveToRegister
        ),
    ];
    }
    else{
      return
    [
      new RaisedButton
      (
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        padding: EdgeInsets.all(12),
        child: new Text("계정 생성", style: new TextStyle(fontSize: 20.0)),
        textColor: Colors.white,
        // color: Colors.pink,
        color: Theme.of(context).accentColor,
        onPressed: validateAndSubmit,
        ),
      new FlatButton
      (
        child: new Text("이미 계정이 있나요? 로그인하기", style: new TextStyle(fontSize: 20.0)), textColor: Theme.of(context).accentColor,
        // textColor: Colors.red,
        
        onPressed: moveToLogin,
        ),
    ];
    }
  }
}