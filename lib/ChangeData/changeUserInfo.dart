import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:online_pharmacy/RegistrationAndLogIn/InputDesign.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:http/http.dart'as http;
import 'dart:convert';
import '../Addition Helper/WidowsHelper.dart';
import '../main.dart';

// ignore: camel_case_types
class changeUserInfo extends StatefulWidget {
  GlobalKey<ScaffoldState> _scaffoldKey;
  changeUserInfo(this._scaffoldKey);
  @override
  _changeUserInfoState createState() => _changeUserInfoState(_scaffoldKey);
}
// ignore: camel_case_types
class _changeUserInfoState extends State<changeUserInfo> {

  GlobalKey<ScaffoldState> _scaffoldKey;
  _changeUserInfoState(this._scaffoldKey);

  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController sex = TextEditingController();
  TextEditingController birthDate = TextEditingController();
  TextEditingController address = TextEditingController();

  TextEditingController addInfo = TextEditingController();
  List<String> infoItems= [];

  addItemToInfo(){
    if(addInfo.text.length>4){
      setState(() {
        infoItems.add(addInfo.text);
        addInfo.clear();
      });
    }

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

  Future _updateData()async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");

    try{
      var response = await http.post(
          getUrl("/api/updatedata"),
          body: {
            'email': email.text,
            'name': name.text,
            'address': address.text,
            'phone': phone.text,
            'gender': sex.text,
            'dob': birthDate.text,
            'disease': json.encode(infoItems),
          },
          headers: {
            "Accept" : "application/json",
            "Authorization" : "Bearer $token"
          }
      );
      print(response.body);
      if(response.statusCode == 200 || response.statusCode == 201){
        if(jsonDecode(response.body)["status"].toString() == "true"){
          showCustomDialog(context, "تم تعديل البيانات بنجاح",
          function: (){
            prefs.setString("phone", jsonDecode(response.body)["data"]["phone"]);
            prefs.setString("name", jsonDecode(response.body)["data"]["name"]);
            prefs.setString("photo", jsonDecode(response.body)["data"]["photo"]);
            prefs.setString("address", jsonDecode(response.body)["data"]["address"]);
          });
        }else{
          showCustomDialog(context, "حدث خطأ يرجي المحاولة مرة اخري",
          myIcon: Icon(Icons.close,size: 55,color: Colors.red,),);
        }
      }else{
        showCustomDialog(context, "حدث خطأ يرجي المحاولة مرة اخري",
          myIcon: Icon(Icons.close,size: 55,color: Colors.red,),);
      }
    }catch(e){
      showCustomDialog(context, "حدث خطأ يرجي المحاولة مرة اخري",
        myIcon: Icon(Icons.close,size: 55,color: Colors.red,),);
    }
    showContainer(false);
  }
  Future getData()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");

    try{
      var response = await http.get(
          getUrl("/api/user"),
          headers: {
            "Accept" : "application/json",
            "Authorization" : "Bearer $token"
          }
      );
      print(response.body);
      if(response.statusCode == 200 || response.statusCode == 201){

        setState(() {
          name.text = jsonDecode(response.body)["name"];
          email.text = jsonDecode(response.body)["email"];
          phone.text = jsonDecode(response.body)["phone"];
          sex.text = jsonDecode(response.body)["gender"];
          birthDate.text = jsonDecode(response.body)["dob"];
          address.text = jsonDecode(response.body)["address"];
          infoItems = jsonDecode(response.body)["disease"]==null?[]:
          jsonDecode(response.body)["disease"];
        });

      }
    }catch(e){}

  }

  @override
  initState(){
    super.initState();
    getData();
    selectedGender = 0;
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
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[

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
                          controller: address,
                          obscure: false,
                          hint: "العنوان",
                          myIcon: Icon(Icons.streetview,color: Colors.grey,),
                          textInputType: TextInputType.url,
                        ),
                        Container(
                          alignment: Alignment.centerRight,
                          padding: EdgeInsets.only(top: 18,right: 8,bottom: 4),
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
                                                if(sex.text.isEmpty ||
                                                    (sex.text.toLowerCase()!="male" &&
                                                        sex.text.toLowerCase()!="female")){
                                                  showSnackBar(context,
                                                      "يرجي تحديد الجنس", scaffoldKey: _scaffoldKey);
                                                }else{
                                                  if(birthDate.text.isEmpty){
                                                    showSnackBar(context,
                                                        "يرجي ادخال تاريخ الميلاد",
                                                        scaffoldKey: _scaffoldKey);
                                                  }else{
                                                    showContainer(true);
                                                    _updateData();
                                                  }
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
                                        onPressed: getData,
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
            ),
          ],
        ),
        myContainer,
      ],
    );
  }
}
