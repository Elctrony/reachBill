import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:online_pharmacy/RegistrationAndLogIn/InputDesign.dart';
import 'package:location/location.dart';
import 'package:online_pharmacy/GetLocation/ShowMap.dart';
import 'package:online_pharmacy/RegistrationAndLogIn/RegistrationThirdPage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../main.dart';
import '../Addition Helper/WidowsHelper.dart';
import 'ShoppingThirdPage.dart';

class ShoppingNextPage extends StatefulWidget {

  @override
  _ShoppingNextPageState createState() => _ShoppingNextPageState();
}
class _ShoppingNextPageState extends State<ShoppingNextPage> {

  double latitude=0.0;
  double longitude=0.0;


  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  LocationData  currentLocation;
  var location = new Location();

  String phone;
  String description;
  int pharmacyId;

  TextEditingController promoCodeController = new TextEditingController();
  String promoCodeResponse;

  Future<Map<String,double>> getCurrentLocation()async{
    Map<String,double> result={
      "latitude":0.0,
      "longitude":0.0
    };
    try {
      currentLocation = await location.getLocation();
      result = {
        "latitude":currentLocation.latitude,
        "longitude":currentLocation.longitude
      };
      setState(() {
        latitude = currentLocation.latitude;
        longitude = currentLocation.longitude;
      });
    }catch (e) {
      currentLocation = null;
    }
    return result;
  }

  Future getDefaultLocation()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    double lat = prefs.getDouble('lat');
    double lng = prefs.getDouble('lng');
    setState(() {
      latitude  = lat;
      longitude = lng;
    });
  }

  Future<String> addPromo(String promo)async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');

    try{
      var response = await http.post(
          getUrl("/api/addpromotouser"),
          body: {
            "code": promo,
          },
          headers: {
            "Accept" : "application/json",
            "Authorization" : "Bearer $token"
          }
      );
      return jsonDecode(response.body)["msg"];

    }catch(exception){
      print(exception);
      return "error";
    }
  }

  void _showMaterialDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: Text('إضافة بروموكود'),
            content: fieldInput(
              enable: true,
              controller: promoCodeController,
              obscure: false,
              hint: "اكتب البروموكود",
              myIcon: Icon(Icons.text_fields,color: Colors.grey,),
              textInputType: TextInputType.text,
            ),
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('الغاء',style: TextStyle(color: Colors.red),)
              ),
              Container(
                height: 50,
                child: Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: RaisedButton(
                    color: Colors.lightBlue.shade600,
                    onPressed: (){
                      Navigator.pop(context);
                      showContainer(true);
                      addPromo(promoCodeController.text).then((value){
                        setState(() {
                          promoCodeResponse = value;
                        });
                        showContainer(false);
                      });
                    },
                    child: Text("بحث", style:
                    TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ),
                ),
              )
            ],
          );
        });
  }



  Future getNearestPharmacy()async{

    try{
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {

        showContainer(true);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String token = prefs.getString('token');

        try{
          var response = await http.post(
              getUrl("/api/nearest"),
              body: {
                "lat":"$latitude",
                "lng":"$longitude",
              },
              headers: {
                "Accept" : "application/json",
                "Authorization" : "Bearer $token"
              }
          );
          print("getNearestPharmacy");
          print(response.body);
          print("=============================");
          if(response.statusCode == 200 || response.statusCode == 201){
            if(response.body.length<6) {
              try{
                pharmacyId = int.parse(jsonDecode(response.body));
              }catch(e){
                showContainer(false);
              }

              await makeTheOrder();
            }
            else {
              showContainer(false);
              showCustomDialog(context, "الخدمه غير متوفره في الموقع المحدد هذا اليوم",
                  myIcon: Icon(Icons.close,size: 55,color: Colors.red,));
            }
          }else {
            showContainer(false);
            showCustomDialog(context, "الخدمه غير متوفره في الموقع المحدد هذا اليوم",
                myIcon: Icon(Icons.close,size: 55,color: Colors.red,));
          }
          print('nearest : ${response.body}');

        }catch(exception){print(exception);}

      }
    }catch(e){
      showContainer(false);
      showCustomDialog(context, "لا يتوفر اتصال بالانترنت",
          myIcon: Icon(Icons.close,size: 55,color: Colors.red,)
      );
    }

  }

  Future makeTheOrder()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');

    description = descriptionController.text;
    phone = phoneController.text;


    print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");

    print(getUrl("/api/addorder"));
    print(description);
    print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
    print(token);

    print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");

    try{
      var response = await http.post(
          getUrl("/api/addorder"),
          body: {
            "address":description,
            "pharmacy_id": "$pharmacyId",
            "phone":phone,
          },
          headers: {
            "Accept" : "application/json",
            "Authorization" : "Bearer $token"
          }
      );
      print("makeTheOrder");
      print(response.body);
      print("=============================");
      if(response.statusCode == 200 || response.statusCode == 201){
        showCustomDialog(context,
            "تم الطلب .. تجري عملية مراجعة طلبك الان , سيتم الرد في اقرب وقت ",function: (){
          Navigator.of(context).pushNamedAndRemoveUntil(
              '/homepage', (Route<dynamic> route) => false);
        });
      }else{
        showContainer(false);
      }

    }catch(exception){print(exception);}
  }



  TextEditingController descriptionController = new TextEditingController();
  TextEditingController phoneController = new TextEditingController();

  Future<Map<String,double>> _navigateAndDisplaySelection(
      BuildContext context,Map result) async {
    final getFromMap = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) =>
          ShowMap(result["longitude"],result["latitude"])),
    );
    return getFromMap;
  }

  @override
  void initState() {
    super.initState();
    setDefaultData();
  }

  setDefaultData()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();

    descriptionController.text = prefs.getString("address");
    phoneController.text = prefs.getString("phone");
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
          backgroundColor: Colors.grey.shade300,
          resizeToAvoidBottomPadding: true,
          key: _scaffoldKey,
          body: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.all(6),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 100,),
                  Container(
                    padding: EdgeInsets.only(left: 4,right: 4),
                    height: 60,
                    width: MediaQuery.of(context).size.width,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: RaisedButton(
                        color: Colors.teal.shade800,
                        onPressed: (){
                          getCurrentLocation().then((result){
                            _navigateAndDisplaySelection(context,result).
                            then((finalResult){
                              setState(() {
                                longitude = finalResult["longitude"];
                                latitude = finalResult["latitude"];
                              });
                            });
                          });
                        },
                        child: Text("تحديد الموقع علي الخريطه", style:
                        TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 12,),
                  Container(
                    padding: EdgeInsets.only(left: 4,right: 4),
                    height: 60,
                    width: MediaQuery.of(context).size.width,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: RaisedButton(
                        color: Colors.teal.shade800,
                        onPressed: getCurrentLocation,
                        child: Text("موقعي الحالي", style:
                        TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 12,),
                  Container(
                    padding: EdgeInsets.only(left: 4,right: 4),
                    height: 60,
                    width: MediaQuery.of(context).size.width,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: RaisedButton(
                        color: Colors.teal.shade800,
                        onPressed: getDefaultLocation,
                        child: Text("اختيار الموقع الاساسي", style:
                        TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20,),
                  Padding(
                    padding: const EdgeInsets.only(left: 22),
                    child: Text("latitude   : $latitude"),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 22),
                    child: Text("longitude: $longitude"),
                  ),

                  SizedBox(height: 10,),


                  Container(
                    padding: EdgeInsets.only(left: 4,right: 4),
                    height: 60,
                    width: MediaQuery.of(context).size.width,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: RaisedButton(
                        color: Colors.teal.shade800,
                        onPressed: (){
                          if(longitude==0.0 || latitude==0.0){
                            showSnackBar(context, "يرجي تحديد الموقع علي الخريطه",
                                scaffoldKey: _scaffoldKey);
                          }else{
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context)=> ShoppingThirdPage(latitude,latitude,location)));
                          }
                        },
                        child: Text("اطلب", style:
                        TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ),
                    ),
                  ),
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

