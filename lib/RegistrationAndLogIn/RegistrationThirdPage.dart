import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:online_pharmacy/RegistrationAndLogIn/InputDesign.dart';
import './API.dart';
import 'package:location/location.dart';
import 'package:online_pharmacy/GetLocation/ShowMap.dart';
import '../Addition Helper/WidowsHelper.dart';

class ThirdPage extends StatefulWidget {

  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController sex = TextEditingController();
  TextEditingController birthDate = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confPassword = TextEditingController();
  List<String> infoItems= [];
  String image;
  double latitude;
  double longitude;

  ThirdPage({this.email,this.name,this.phone,this.sex,this.birthDate,
    this.password,this.confPassword,this.infoItems, this.image = "", this.latitude,this.longitude});
  @override
  _ThirdPageState createState() => _ThirdPageState();
}
class _ThirdPageState extends State<ThirdPage> {

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  LocationData  currentLocation;

  TextEditingController description = new TextEditingController();

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
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      resizeToAvoidBottomPadding: true,
      key: _scaffoldKey,
      body: Stack(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.all(6),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 100,),

                  fieldInput(
                    enable: true,
                    controller: description,
                    obscure: false,
                    hint: "وصف العنوان",
                    myIcon: Icon(Icons.description,color: Colors.grey,),
                    textInputType: TextInputType.text,
                  ),
                  SizedBox(height: 20,),
                  Container(
                    padding: EdgeInsets.only(left: 4,right: 4),
                    height: 60,
                    width: MediaQuery.of(context).size.width,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: RaisedButton(
                        color: Colors.teal.shade800,
                        onPressed: (){
                            if(description.text.length<10){
                              showSnackBar(context,
                                  "يرجي كتابه عنوانك بالتفصيل",
                                  scaffoldKey: _scaffoldKey);
                            }else{
                              showContainer(true);
                              registrationRequest(
                                  lat: widget.latitude,
                                  lng: widget.longitude,
                                  email: widget.email.text.toString(),
                                  name: widget.name.text.toString(),
                                  password: widget.password.text.toString(),
                                  conPassword: widget.confPassword.text.toString(),
                                  dOfB: widget.birthDate.text.toString(),
                                  gender: widget.sex.text.toLowerCase(),
                                  phone: widget.phone.text.toString(),
                                  photo: widget.image,
                                  address: description.text.toString(),
                                  disease: widget.infoItems,
                                  callBack: (){
                                    showCustomDialog(context,"تم تسجيل الحساب بنجاح",
                                        function: (){
                                          Navigator.of(context).pushNamedAndRemoveUntil('/logIn',
                                                  (Route<dynamic> route) => false);
                                        });
                                  },
                                  rejectCallBack: (msg){
                                    showContainer(false);
                                    showCustomDialog(context,
                                        "$msg",
                                        myIcon: Icon(Icons.close,size: 60,color: Colors.red,)
                                    );
                                  }
                              );
                          }
                        },
                        child: Text("تسجيل", style:
                        TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          myContainer,
        ],

      ),
    );
  }
}

