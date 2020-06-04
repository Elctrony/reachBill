import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:online_pharmacy/RegistrationAndLogIn/InputDesign.dart';
import './Registration.dart';
import '../HomePage/HomePage.dart';
import './API.dart';
import '../Addition Helper/WidowsHelper.dart';

class LogIn extends StatefulWidget {
  @override
  _LogInState createState() => _LogInState();
}

class _LogInState extends State<LogIn> {

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();
  bool passwordObscure = true;

  Container myContainer = new Container();

  showContainer(bool state){
    if(state){
      setState(() {
        myContainer = Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: Colors.black54,
          child: Center(
            child: Container(
                width: 50,
                height: 50,
                child: CircularProgressIndicator()
            ),
          ),
        );
      });
    }else{
      setState(() {
        myContainer = new Container();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
//    ScreenUtil.instance = ScreenUtil.getInstance()..init(context);
//    ScreenUtil.instance =
//        ScreenUtil(width: 750, height: 1334, allowFontScaling: true);
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomPadding: true,
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: new BoxDecoration(
          image: new DecorationImage(
              image: new AssetImage('images/background.jpg'),
              fit: BoxFit.cover
            //fit: BoxFit.none,
          ),
        ),
        child: Stack(
          children: <Widget>[
            Container(
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 50,),
                    Container(
                      height: 150,
                      width: 200,
                      child: Image(
                        image: AssetImage("images/new_reachpill.png"),
                        color: Colors.teal,),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 4,right: 4),
                      child: fieldInput(
                        obscure: false,
                        hint: "رقم الموبايل او البريد الالكتروني",
                        controller: username,
                        myIcon: Icon(Icons.person_outline,color: Colors.grey,),
                        textInputType: TextInputType.emailAddress,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4),
                      child: fieldInput(
                        obscure: passwordObscure,
                        hint: "كلمه السر",
                        controller: password,
                        myIcon: Icon(Icons.remove_red_eye,color: Colors.grey,),
                        textInputType: TextInputType.text,
                        iconOnPressed: (){
                          setState(() {
                            passwordObscure = !passwordObscure;
                          });
                        },
                      ),
                    ),
                    SizedBox(height: 16,),
                    Container(
                      padding: EdgeInsets.only(left: 8,right: 8),
                      height: 55,
                      width: double.maxFinite,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: RaisedButton(
                          color: Colors.teal.shade800,
                          onPressed: () async {

                            if(username.text.isEmpty || username.text.length<10){
                              showSnackBar(context,
                                  "يرجي ادخال البريد الالكتروني",
                                  scaffoldKey: _scaffoldKey);
                            }else{
                              if(password.text.isEmpty || password.text.length<=0){
                                showSnackBar(context,
                                    "يرجي ادخال كلمة المرور",
                                    scaffoldKey: _scaffoldKey);
                              }else{
                                try{
                                  var result = await InternetAddress.lookup('google.com');
                                  if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {}

                                  try {
                                    var result = await InternetAddress.lookup('google.com');
                                    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {

                                      showContainer(true);

                                      logInRequest(
                                        email: username.text,
                                        password: password.text,
                                        callBack: (){
                                          Navigator.of(context).pushNamedAndRemoveUntil(
                                              '/homepage', (Route<dynamic> route) => false);
                                        },
                                        rejectCallBack: (){
                                          showContainer(false);
                                          showCustomDialog(context,
                                              "حدث خطأ اثناء الدخول يرجي المحاوله مره اخري",
                                              myIcon: Icon(Icons.close,size: 60,color: Colors.red,));
                                          showContainer(false);
                                        },
                                      );

                                    }
                                  }catch(e){
                                    showCustomDialog(context, "لا يتوفر اتصال بالانترنت",
                                        myIcon: Icon(Icons.close,size: 55,color: Colors.red,));
                                  }

                                }catch(e){
                                  showContainer(false);
                                  showCustomDialog(context, "لا يتوفر اتصال بالانترنت",
                                      myIcon: Icon(Icons.close,size: 55,color: Colors.red,));                                }
                              }
                            }
                          },
                          child: Text("دخول", style:
                          TextStyle(color: Colors.white, fontSize: 20),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 16,),

                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[

//                          Expanded(
//                            child: Container(
//                              padding: EdgeInsets.only(left: 8,right: 8),
//                              height: 55,
//                              child: ClipRRect(
//                                borderRadius: BorderRadius.circular(6),
//                                child: RaisedButton(
//                                  onPressed: (){},
//                                  color: Colors.blue.shade900,
//                                  child: Text("تسجيل بفيسبوك", style:
//                                  TextStyle(color: Colors.white,
//                                      fontSize: 18),
//                                  ),
//                                ),
//                              ),
//                            ),
//                          ),
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.only(left: 8,right: 8),
                              height: 55,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(6),
                                child: RaisedButton(
                                  color: Colors.teal.shade800,
                                  onPressed: (){
                                    Navigator.push(context,
                                      MaterialPageRoute(builder: (context) => Registration()),
                                    );
                                  },

                                  child: Text("انشاء حساب", style:
                                  TextStyle(color: Colors.white,
                                      fontSize: 20),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height-(150+250+100),),
                    Container(
                      child: Center(
                        child: Text("هل نسيت كلمه السر؟",style: TextStyle(
                            color: Colors.white,fontSize: 16,fontWeight: FontWeight.w700,decoration: TextDecoration.underline),),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            myContainer,
          ],
        ),
      ),
    );
  }
}
