import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:online_pharmacy/RegistrationAndLogIn/LogIn.dart';
import 'package:online_pharmacy/RegistrationAndLogIn/Registration.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

void showCustomDialog(BuildContext myContext,String action,
    {Icon myIcon = const Icon(Icons.check,size: 60,color: Colors.blue,),
      Function function}){
  showDialog(barrierDismissible: false,
      context: myContext,
      builder: (BuildContext context){
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text("يرجي الانتباه"),
          content: new Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                myIcon,
                Flexible(child: Text(action
                  ,style: TextStyle(fontSize: 18),textAlign: TextAlign.center,))
              ],
            ),
          ),
          actions: <Widget>[
            new FlatButton.icon(
                onPressed:(){
                  Navigator.pop(context);
                  if(function != null) function();
                },
                icon: new Icon(Icons.check),
                label: Text("إستمرار")
            ),
          ],
        );
      }
  );
}


void showLoginDialog(BuildContext myContext){
        Alert(
          context: myContext,
          type: AlertType.warning,
          title: "انتباه",
          desc: "برجاء تسجيل الدخول أولا...",
          buttons: [
            DialogButton(
              child: Text(
                "تسجيل الدخول",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              onPressed: () => Navigator.push(myContext, MaterialPageRoute(builder: (myContext)=>LogIn())),
              color: Color.fromRGBO(0, 179, 134, 1.0),
            ),
            DialogButton(
              child: Text(
                "تسجيل",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              onPressed: () =>  Navigator.push(myContext, MaterialPageRoute(builder: (myContext)=> Registration())),
              gradient: LinearGradient( colors: [Colors.cyan,Colors.teal,Colors.teal.shade900]),
            )
          ],
        ).show();
}

void showSnackBar(BuildContext context,String value,
    {GlobalKey<ScaffoldState> scaffoldKey,int duration = 3}) {
  FocusScope.of(context).requestFocus(new FocusNode());
  scaffoldKey.currentState?.removeCurrentSnackBar();
  scaffoldKey.currentState.showSnackBar(new SnackBar(
    behavior: SnackBarBehavior.fixed,

    content: new Text(
      value,
      textAlign: TextAlign.center,
      style: TextStyle(
          color: Colors.grey.shade300,
          fontSize: 18.0,fontWeight: FontWeight.bold,
          fontFamily: "WorkSansSemiBold"),
    ),
    backgroundColor: Colors.black87.withBlue(10),
    duration: Duration(seconds: duration),
  ));
}