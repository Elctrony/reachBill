import'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:http/http.dart'as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../Addition Helper/WidowsHelper.dart';
import '../RegistrationAndLogIn/InputDesign.dart';
import '../main.dart';


// ignore: camel_case_types
class changePass extends StatefulWidget {
  GlobalKey<ScaffoldState> _scaffoldKey;
  changePass(this._scaffoldKey);
  @override
  _changePassState createState() => _changePassState(_scaffoldKey);
}
// ignore: camel_case_types
class _changePassState extends State<changePass> {

  GlobalKey<ScaffoldState> _scaffoldKey;
  _changePassState(this._scaffoldKey);

  bool obscureOld = true;
  bool obscureNew = true;

  TextEditingController oldPassword = TextEditingController();
  TextEditingController newPassword1 = TextEditingController();
  TextEditingController newPassword2 = TextEditingController();


  Future changePassword() async{

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');

    try{
      var response = await http.post(
        getUrl("/api/changepassword"),
        body: {
          "oldpassword" : oldPassword.text,
          "newpassword" : newPassword1.text,
        },
        headers: {
          "Accept" : "application/json",
          "Authorization" : "Bearer $token"
        }
      );
      print("change password: "+response.body);
      if(response.statusCode == 200 || response.statusCode == 201){
        if(jsonDecode(response.body)["status"].toString() == "true"){
          showCustomDialog(context, "تم تغيير كلمة المرور بنجاح",function: (){
            oldPassword.clear();
            newPassword1.clear();
            newPassword2.clear();
          });

        }else{
          String action = jsonDecode(response.body)["error"];
          showCustomDialog(context, action,
            myIcon: Icon(Icons.close,size: 55,color: Colors.red,),);
        }

      }else{
        showCustomDialog(context, "حدث خطأ يرجي المحاولة مرة اخري",
          myIcon: Icon(Icons.close,size: 55,color: Colors.red,),);
      }
    }catch(exception){print(exception);}
    showContainer(false);
  }

  @override
  initState(){
    super.initState();
  }

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
    return Stack(
      children: <Widget>[
        ListView(
          children: <Widget>[
            Container(
              color: Colors.white,
              child: Padding(
                padding:
                    const EdgeInsets.only(left: 6, right: 6, top: 8, bottom: 16),
                child: Card(
                  color: Colors.grey.shade200,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide(color: Colors.black12)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: Icon(Icons.lock),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: Text("تغيير كلمة المرور", style: TextStyle(fontSize: 20,
                              color: Colors.teal,),),
                          ),
                        ],
                      ),

                      Padding(
                        padding: const EdgeInsets.only(left: 4,right: 4,top: 8),
                        child: fieldInput(
                          controller: oldPassword,
                          obscure: obscureOld,
                          hint: "كلمة المرور القديمة",
                          myIcon: Icon(Icons.remove_red_eye,color: Colors.teal,),
                          textInputType: TextInputType.text,
                          iconOnPressed: (){
                            setState(() {
                              obscureOld = !obscureOld;
                            });
                          },
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(left: 4,right: 4),
                        child: fieldInput(
                          controller: newPassword1,
                          obscure: obscureNew,
                          hint: "كلمة المرور الجديدة",
                          myIcon: Icon(Icons.remove_red_eye,color: Colors.teal,),
                          textInputType: TextInputType.text,
                          iconOnPressed: (){
                            setState(() {
                              obscureNew = !obscureNew;
                            });
                          },
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(left: 4,right: 4),
                        child: fieldInput(
                          controller: newPassword2,
                          obscure: obscureNew,
                          hint: "تأكيد كلمة المرور",
                          myIcon: Icon(Icons.remove_red_eye,color: Colors.teal,),
                          textInputType: TextInputType.text,
                          iconOnPressed: (){
                            setState(() {
                              obscureNew = !obscureNew;
                            });
                          },
                        ),
                      ),

                      SizedBox(height: 12,),
                      Container(
                        margin: EdgeInsets.only(top: 16),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Container(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(6),
                                    child: RaisedButton(
                                        color: Colors.teal.shade800,
                                        onPressed: (){
                                          if (oldPassword.text.isEmpty){
                                            showSnackBar(context, "يرجي ادخال كلمة المرور القديمة",scaffoldKey: _scaffoldKey);
                                          }else{
                                            if (newPassword1.text.isEmpty){
                                              showSnackBar(context, "يرجي ادخال كلمة المرور الجديدة",scaffoldKey: _scaffoldKey);
                                            }else{
                                              if (newPassword2.text.isEmpty){
                                                showSnackBar(context, "يرجي ادخال تأكيد كلمة المرور",scaffoldKey: _scaffoldKey);
                                              }else{
                                                if(newPassword1.text!=newPassword2.text){
                                                  showSnackBar(context, "كلمتا المرور غير متطابقتان",scaffoldKey: _scaffoldKey);
                                                }else{
                                                  showContainer(true);
                                                  changePassword();
                                                }
                                              }
                                            }
                                          }
                                        },
                                        child: Text("حفظ",style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w700,height: 2),
                                        ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Container(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(6),
                                    child: RaisedButton(
                                      color: Colors.red.shade900,
                                      onPressed: (){
                                        oldPassword.clear();
                                        newPassword1.clear();
                                        newPassword2.clear();
                                      },
                                      child: Text("الغاء",style: TextStyle(
                                          color: Colors.white,fontWeight: FontWeight.w700,
                                          height: 2),),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        myContainer,
      ],
    );
  }
}
