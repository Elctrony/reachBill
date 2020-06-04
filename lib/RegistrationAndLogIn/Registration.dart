import 'dart:io';
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:online_pharmacy/RegistrationAndLogIn/InputDesign.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:online_pharmacy/UploadImage/UploadImage.dart';
import './RegistrationSecondPage.dart';
import '../Addition Helper/WidowsHelper.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;


class Registration extends StatefulWidget {

  @override
  _RegistrationState createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {

  File _image;
  String imageNameFromServer = "";
  Future _getImageFromGallery() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image= image;
    });

    List imageInList = await uploadingImages([_image]);
    for(var image in imageInList)
      imageNameFromServer = image;
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController sex = TextEditingController();
  TextEditingController birthDate = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confPassword = TextEditingController();
  TextEditingController addInfo = TextEditingController();

  List<String> infoItems= [];

  addItemToInfo(){
    setState(() {
      infoItems.add(addInfo.text);
    });
  }
  getCards(){
    List<Card> myCards = [];
    for(int i=0; i<infoItems.length;i++){
      myCards.add(
        Card(
          child: Chip(
            deleteIconColor: Colors.red.shade900,
            backgroundColor: Colors.white,
            padding: EdgeInsets.all(8),
            label: Text(infoItems[i]),
            onDeleted: (){
              setState(() {
                infoItems.removeAt(i);
              });
            },
          ),
        )
      );
    }
    return myCards;
  }

  @override
  void initState() {
    super.initState();
    selectedGender = 0;
  }
  int selectedGender;
  void _checkGender(context){
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Container(
                height: 200,
                child: Column(
                  children: <Widget>[
                    RadioListTile(
                      value: 1,
                      groupValue: selectedGender,
                      onChanged: (int value){
                        setState(() {
                          selectedGender = value;
                        });
                        sex.text = "Male";
                      },
                      title: Text("Male"),
                    ),
                    RadioListTile(
                      value: 2,
                      groupValue: selectedGender,
                      onChanged: (int value){
                        setState(() {
                          selectedGender = value;
                        });
                        sex.text = "Female";
                      },
                      title: Text("Female"),
                    ),
                  ],
                ),
              );
            });
        });
  }

  @override
  Widget build(BuildContext context) {
//    ScreenUtil.instance  = ScreenUtil.getInstance()..init(context);
//    ScreenUtil.instance  = ScreenUtil(
//      width: 750,
//      height: 1334,
//      allowFontScaling: true,
//    );
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.grey.shade300,
      resizeToAvoidBottomPadding: true,
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(8),
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(top: 30),
                      child: Center(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: Container(
                            decoration: new BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(),
                            ),
                            child: _image==null?Image(
                              image: AssetImage("images/user.png"),
                              width:85,height:85,):
                            Image.file(_image,width: 85,height: 85,fit: BoxFit.cover,),
                          ),
                        )
                      ),
                    ),
                    Container(
                      child: RaisedButton(
                        shape: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey.shade700)
                        ),
                        onPressed: (){
                          if(false) _getImageFromGallery();
                        },
                        child: Text("اضف صورة شخصية",
                          style: TextStyle(fontWeight: FontWeight.w700),),
                      ),

                    ),

                    SizedBox(height: 16,),


                    fieldInput(
                      controller: name,
                      hint: "الاسم",
                      obscure: false,
                      myIcon: Icon(Icons.person,color: Colors.grey,),
                      textInputType: TextInputType.text,
                    ),
                    fieldInput(
                      controller: email,
                      obscure: false,
                      hint: "البريد الالكتروني",
                      myIcon: Icon(Icons.mail_outline,color: Colors.grey,),
                      textInputType: TextInputType.emailAddress,
                    ),
                    fieldInput(
                      controller: phone,
                      obscure: false,
                      hint: "رقم الموبايل",
                      myIcon: Icon(Icons.phone,color: Colors.grey,),
                      textInputType: TextInputType.phone,
                    ),
                    InkWell(
                      onTap: (){
                        _checkGender(context);
                      },
                      child: fieldInput(
                        controller: sex,
                        obscure: false,
                        hint: "النوع",
                        enable: false,
                        myIcon: Icon(Icons.keyboard_arrow_down,color: Colors.grey,),
                        textInputType: TextInputType.url,
                      ),
                    ),
                    InkWell(
                      onTap: (){
                        {
                          DatePicker.showDatePicker(
                            context,
                            showTitleActions: true,
                            minTime: DateTime(1950, 3, 5),
                            maxTime: DateTime.now().subtract(Duration(days: 365*18)),
                            onChanged: (date) {
                              setState(() {
                                birthDate.value = TextEditingValue(
                                    text: "${date.toString().substring(0,10)}");
                              });
                              print('change $date');
                            },
                            onConfirm: (date) {
                              print("${date.toString().substring(0,10)}");
                            },
                            currentTime: DateTime.now(), locale: LocaleType.en,
                          );
                          print("work");
                        }
                      },
                      child: fieldInput(
                        enable: false,
                        controller: birthDate,
                        obscure: false,
                        hint: "تاريخ الميلاد",
                        myIcon: Icon(Icons.date_range,color: Colors.grey,),
                        textInputType: TextInputType.text,
                      ),
                    ),
                    fieldInput(
                      hint: "كلمه السر",
                      obscure: true,
                      controller: password,
                      myIcon: Icon(Icons.lock_open,color: Colors.grey,),
                    ),
                    fieldInput(
                      hint: "تأكيد كلمه السر",
                      obscure: true,
                      controller: confPassword,
                      myIcon: Icon(Icons.lock_open,color: Colors.grey,),
                    ),
                    Container(
                      alignment: Alignment.centerRight,
                      padding: EdgeInsets.only(top: 14,right: 8,bottom: 4),
                      child: Text("هل تعاني من اي امراض مزمنة؟",),
                    ),
                    fieldInput(
                      hint: "اضف",
                      obscure: false,
                      controller: addInfo,
                      myIcon: Icon(Icons.add,color: Colors.grey,),
                      iconOnPressed: addItemToInfo,
                    ),
                    SizedBox(height: 12,),
                    Container(
                      alignment: Alignment.centerRight,
                      child: Wrap(
                        children: getCards(),
                        direction: Axis.horizontal,
                        crossAxisAlignment: WrapCrossAlignment.start,
                        textDirection: TextDirection.rtl,
                        alignment: WrapAlignment.start,
                        runAlignment: WrapAlignment.start,

                      ),
                    ),
                    SizedBox(height: 22,),
                    Container(
                      padding: EdgeInsets.only(left: 4,right: 4),
                      height: 60,
                      width: MediaQuery.of(context).size.width,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: RaisedButton(
                          color: Colors.teal.shade800,
                          onPressed: (){
                            if(name.text.isEmpty){
                              showSnackBar(context,
                                  "يرجي ادخال الاسم", scaffoldKey: _scaffoldKey);
                            }else{
                              if(email.text.isEmpty || !(email.text.contains("@"))
                              || !(email.text.contains(".com"))){
                                showSnackBar(context,
                                    "يرجي ادخال بريد الكتروني صحيح",
                                    scaffoldKey: _scaffoldKey);
                              }else{
                                if(phone.text.isEmpty || phone.text.length!=11){
                                  showSnackBar(context,
                                      "يرجي ادخال رقم هاتف صحيح", scaffoldKey: _scaffoldKey);
                                }else{
                                  if(sex.text.isEmpty){
                                    showSnackBar(context,
                                        "يرجي تحديد الجنس", scaffoldKey: _scaffoldKey);
                                  }else{
                                    if(birthDate.text.isEmpty){
                                      showSnackBar(context,
                                          "يرجي ادخال تاريخ الميلاد",
                                          scaffoldKey: _scaffoldKey);
                                    }else{
                                      if(password.text.isEmpty){
                                        showSnackBar(context,
                                            "يرجي ادخال كلمة المرور",
                                            scaffoldKey: _scaffoldKey);
                                      }else{
                                        if(confPassword.text.isEmpty){
                                          showSnackBar(context,
                                              "يرجي ادخال تأكيد كلمة المرور",
                                              scaffoldKey: _scaffoldKey);
                                        }else{
                                          if(confPassword.text!=password.text){
                                            showSnackBar(context,
                                                "كلمه السر غير متطابقة",
                                                scaffoldKey: _scaffoldKey);
                                          }else{
                                            Navigator.push(context,
                                                MaterialPageRoute(
                                                    builder: (context)=> SecondPage(
                                                      email: email,
                                                      name: name,
                                                      password: password,
                                                      confPassword: confPassword,
                                                      birthDate: birthDate,
                                                      sex: sex,
                                                      phone: phone,
                                                      image: imageNameFromServer,
                                                      infoItems: infoItems,
                                                    )
                                                )
                                            );
                                          }
                                        }
                                      }
                                    }
                                  }
                                }
                              }
                            }
                          },
                          child: Text("التالي", style:
                          TextStyle(color: Colors.white, fontSize: 18),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      child: Center(
                        child: InkWell(
                          onTap: ()=>Navigator.pop(context),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Text("رجوع",style: TextStyle(
                              fontSize: 18,color: Colors.teal.shade800,fontWeight: FontWeight.w700
                            ),),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

