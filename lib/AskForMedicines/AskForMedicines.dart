import 'dart:io';
import 'package:flutter/material.dart';
import '../RegistrationAndLogIn/InputDesign.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import './asset_view.dart';
import '../UploadImage/UploadImage.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Addition Helper/WidowsHelper.dart';

class AskMedicines extends StatefulWidget {
  @override
  _AskMedicinesState createState() => _AskMedicinesState();
}

class _AskMedicinesState extends State<AskMedicines> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  TextEditingController controller = TextEditingController();

  List<File> _images = [];
  Future _getImageFromGallery() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _images.add(image);
    });
  }
  Future _getImageFromCamera() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);

    setState(() {
      _images.add(image);
    });
  }

  Widget buildGridView() {
    return GridView.count(
      mainAxisSpacing: 3,crossAxisSpacing: 3,
      scrollDirection: Axis.vertical,
      crossAxisCount: 5,
      children: List.generate(_images.length, (index) {
        return AssetView(index, _images[index]);
      }),
    );
  }

  List<String> infoItems= [];
  List imagesName= [];

  addItemToInfo(){
    if(controller.text.length>3){
      setState(() {
        infoItems.add(controller.text);
        controller.clear();
      });
    }else{
    }

  }
  getCards() {
    List<Card> myCards = [];
    for(int i=0; i<infoItems.length;i++){
      myCards.add(
          Card(
            elevation: 3.0,
            child: Row(
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.remove_circle,color: Colors.red,size: 35,),
                  onPressed: (){
                    setState(() {
                      infoItems.removeAt(i);
                    });
                  }
                ),
                Expanded(child: Container()),
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Text(infoItems[i]),
                ),
              ],
            ),
          )
      );
    }
    return myCards;
  }

  Future addToCart()async{
    try{

      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {

        showSnackBar(context, "يتم اضافة الطلب برجاء الانتظار",scaffoldKey: _scaffoldKey);
        imagesName = await uploadingImages(_images);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String token = prefs.getString('token');
        try{
          var response = await http.post(
              getUrl("/api/addproduct"),
              body: {
                "data" : infoItems.length>0?jsonEncode(infoItems):"",
                "image" : imagesName.length>0?jsonEncode(imagesName):"",
                "type" : "med",
              },
              headers: {
                "Accept" : "application/json",
                "Authorization" : "Bearer $token"
              }
          );
          print(response.body);
          if(jsonDecode(response.body)["status"].toString()=="true"){
            showCustomDialog(context, "تم اضافة الطلب بنجاح",
                function:(){
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      '/homepage', (Route<dynamic> route) => false);
                });
          }else{
            showCustomDialog(context, "خطأ في إضافة الطلب برجاء المحاولة مره اخري");
          }
        }catch(e){
          print(e.toString());
          showContainer(false);
          showCustomDialog(context, "خطأ في إضافة الطلب برجاء المحاولة مره اخري");
        }

      }else{
        showContainer(false);
        showCustomDialog(context, "لا يتوفر اتصال بالانترنت",
            myIcon: Icon(Icons.close,size: 55,color: Colors.red,));
      }

    }catch(e){
      showContainer(false);
      showCustomDialog(context, "لا يتوفر اتصال بالانترنت",
          myIcon: Icon(Icons.close,size: 55,color: Colors.red,));
    }
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
        Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            backgroundColor: Colors.grey.shade200,
            leading: IconButton(
              icon: Icon(Icons.arrow_back,size: 30,color: Colors.black,),
              onPressed: ()=>Navigator.pop(context),
            ),
            title: Container(
              alignment: Alignment.centerRight,
              child: Text("اطلب ادوية",style: TextStyle(
                  color: Colors.teal.shade600,fontSize: 16,fontWeight: FontWeight.w700
              ),textAlign: TextAlign.right,),
            ),
            //centerTitle: true,
          ),
          body: SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height,
              color: Colors.grey.shade200,
              child: ListView(
                scrollDirection: Axis.vertical,
               physics: ScrollPhysics(),
                shrinkWrap: true,
                children: <Widget>[
                  SizedBox(height: 30,),

                  Container(
                    padding: EdgeInsets.all(8),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(7),
                              child: InkWell(
                                onTap: _getImageFromGallery,
                                child: Container(
                                  height: MediaQuery.of(context).size.width/2-60,
                                  width: MediaQuery.of(context).size.width/2,
                                  color: Colors.teal.shade800,
                                  child: Column(
                                    children: <Widget>[
                                      Expanded(
                                        child: Container(
                                          padding: EdgeInsets.only(top: 8),
                                          child: Icon(
                                            Icons.camera,size: 65,
                                            color: Colors.white,)
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          padding: EdgeInsets.only(top: 14),
                                          child: Text("اختر صورة",style: TextStyle(
                                              color: Colors.white,fontSize: 15,fontWeight: FontWeight.w700
                                          ),),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(7.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(7),
                              child: InkWell(
                                onTap: _getImageFromCamera,
                                child: Container(
                                  height: MediaQuery.of(context).size.width/2-60,
                                  width: MediaQuery.of(context).size.width/2,
                                  color: Colors.teal.shade800,
                                  child: Column(
                                    children: <Widget>[
                                      Expanded(
                                        child: Container(
                                          padding: EdgeInsets.only(top: 8),
                                          child: Icon(
                                            Icons.camera_alt,size: 65,
                                            color: Colors.white,)
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          padding: EdgeInsets.only(top: 14),
                                          child: Text("التقط صورة",style: TextStyle(color: Colors.white,
                                              fontSize: 15,fontWeight: FontWeight.w700
                                          ),),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: fieldInput(
                      hint: "اكتب اسم الدواء",
                      myIcon: Icon(Icons.add_circle,color: Colors.teal,size: 35,),
                      textInputType: TextInputType.text,
                      obscure: false,
                      controller: controller,
                      iconOnPressed: addItemToInfo,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      children: <Widget>[
                        Container(
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 8,right: 8),
                              child: Text("تفاصيل الطلب"),
                            ),
                          alignment: Alignment.centerRight,
                        ),

                        _images.length==0?Text(""):
                        Container(
                          height: 100,
                          padding: EdgeInsets.all(4),
                          constraints: BoxConstraints.loose(Size.square(
                              MediaQuery.of(context).size.width
                          )),
                          child: Padding(padding: const EdgeInsets.all(1.0),
                            child:buildGridView(),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                        alignment: Alignment.centerRight,
                        child: Column(
                          children: getCards(),
                          crossAxisAlignment: CrossAxisAlignment.start,
                          textDirection: TextDirection.rtl,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(14),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: RaisedButton(
                        color: Colors.teal.shade700,
                        padding: EdgeInsets.all(8),
                        onPressed: (){
                          if(userToken!=null ) {
                            if (_images.length == 0 && infoItems.length == 0) {
                              showSnackBar(context, "يرجي اخيار صوره او دواء",
                                  scaffoldKey: _scaffoldKey);
                            } else {
                              showContainer(true);
                              addToCart();
                            }
                          }
                          else {
                            showLoginDialog(context);
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Text("اضف الي العربة",style: TextStyle(
                              color: Colors.white,fontWeight: FontWeight.w700,fontSize: 16),),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 75,),

                ],

              ),
            ),
          ),
        ),
        myContainer,
      ],
    );
  }
}

