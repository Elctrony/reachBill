import 'dart:io';
import 'package:flutter/material.dart';
import 'package:online_pharmacy/Addition%20Helper/WidowsHelper.dart';
import 'package:online_pharmacy/ShoppingCart/ShoppingCart.dart';
import 'package:online_pharmacy/cosmeticsShop/MainPages/Children.dart';
import 'package:online_pharmacy/cosmeticsShop/MainPages/Men.dart';
import 'package:online_pharmacy/cosmeticsShop/MainPages/PersonalCare.dart';
import 'package:online_pharmacy/cosmeticsShop/MainPages/Women.dart';
import './Cosmetics.dart';
import 'package:carousel_pro/carousel_pro.dart';
import './Package.dart';
import '../AskForMedicines/AskForMedicines.dart';
import '../Drawer/DrawerPage.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async';
import '../main.dart';
import 'package:shared_preferences/shared_preferences.dart';

bool globalNotificationState;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  List packages = [];
  List<NetworkImage> topImages;

  List topImagesFromApi;
  List packagesFromApi;

  Future getMyTopImages()async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');
    try{
      var response = await http.get(
          getUrl("/api/acceptedads"),
          headers: {
            "Accept" : "application/json",
            "Authorization" : "Bearer $token"
          }
      );
      print(response.body);
      topImagesFromApi = jsonDecode(response.body);
      List<NetworkImage> _images = [];
      for(var item in topImagesFromApi){
        _images.add(
            NetworkImage(getUrl("/images/${item["image"]}"),scale: 1)
        );
        setState(() {
          topImages = _images;
        });
      }
    }catch(e){}
  }
  Future getMyPackages()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');
    try{
      var response = await http.get(
          getUrl("/api/getpackages"),
          headers: {
            "Accept" : "application/json",
            "Authorization" : "Bearer $token"
          }
      );
      packagesFromApi = jsonDecode(response.body);
      for(var item in packagesFromApi){
        setState(() {
          packages.add({'image': item["image"], 'id': item["id"]});
        });
      }
    }catch(e){}
  }
  @override
  void initState() {
    super.initState();
    checkConnection();
  }

  checkConnection()async{
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        await getMyTopImages();
        await getMyPackages();
      }
    }catch(e){
      showCustomDialog(context, "لا يتوفر اتصال بالانترنت",
          myIcon: Icon(Icons.close,size: 55,color: Colors.red,));
    }
  }

  @override
  Widget build(BuildContext context) {
    //precacheImage(AssetImage("images/app_logo/reachpill.png"), context);
    return Scaffold(
      key: _scaffoldKey,
      drawer: DrawerPage(),
      appBar: AppBar(
        title: Row(
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.local_grocery_store,size: 30,color:Colors.teal),
              onPressed: (){
              if(userToken!=null)
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context)=> ShoppingCart())
                );
              else showLoginDialog(context);
              },
            ),
            SizedBox(width: 30,),
            Image(
              image: AssetImage("images/new_reachpill.png"),
              color: Colors.teal,
              //size: 150,
            ),
          ],
        ),
        actions: <Widget>[],
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.menu,size: 30,color: Colors.teal,),
          onPressed: ()=> _scaffoldKey.currentState.openDrawer(),
        ),
        backgroundColor: Colors.grey.shade100,
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.grey.shade100,
          child: Column(
            children: <Widget>[
              Container(
                child: Padding(
                  padding: const EdgeInsets.only(bottom:4,top:8,left:8,right:8),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: 150.0,
                      child: topImages !=null ? topImages.length==0?
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.grey)
                        ),
                        child: Center(
                          child: Icon(Icons.photo_library),
                        ),
                      ):Carousel(
                        boxFit: BoxFit.cover,
                        autoplayDuration: Duration(seconds: 10),
                        autoplay: true,
                        animationCurve: Curves.fastOutSlowIn,
                        animationDuration: Duration(milliseconds: 1000),
                        showIndicator: false,
                        images: topImages,
                        overlayShadow: true,
                        overlayShadowSize: 0.4,
                        overlayShadowColors: Colors.grey.shade300,
                      ):Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.grey)
                        ),
                        child: Image(image: AssetImage("images/loading.gif"),
                          width: MediaQuery.of(context).size.width,),
                      ),
                    ),
                  ),
                ),
              ),

              Container(
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: InkWell(
                    onTap: (){
                      userToken!=null ?
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context)=>AskMedicines())
                      ):showLoginDialog(context);
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.teal.shade700,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(top:8.0,bottom: 8.0,
                              left: 12.0,right: 12.0),
                          child: Row(
                            children: <Widget>[
                              Container(
                                child: Icon(Icons.photo_camera,
                                  size: 35,color: Colors.white,),
                              ),
                              Expanded(child: SizedBox()),
                              Text("اطلب ادوية",style: TextStyle(fontSize: 20,
                                  color: Colors.white,fontWeight:FontWeight.w700 ),),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 4,right: 10),
                      child: Text("مستحضرات تجميل",style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,color: Colors.grey.shade700,
                      ),),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 6,right: 6),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Cosmetics(
                              isImage: false,
                              color: Color(0xff457c64),
                              title: "اخري",
                              image: "images/product.png",
                              function: (){
                                Navigator.push(context,
                                  MaterialPageRoute(builder: (context)=> PersonalCare()),
                                );
                              },
                            ),
                          ),
                          Expanded(
                            child: Cosmetics(
                              color: Color(0xffd8d828),
                              title: "اطفال",
                              image: "images/c_child.jpg",
                              function: (){
                                Navigator.push(context,
                                  MaterialPageRoute(builder: (context)=> Children()),
                                );
                              },
                            ),
                          ),
                          Expanded(
                            child: Cosmetics(
                              color: Color(0xffef7192),
                              title: "سيدات",
                              image: "images/c_women.jpg",
                              function: (){
                                Navigator.push(context,
                                  MaterialPageRoute(builder: (context)=> Women()),
                                );
                              },
                            ),
                          ),
                          Expanded(
                            child: Cosmetics(
                              color: Color(0xff37a4e7),
                              title: "رجالي",
                              image: "images/c_men.jpg",
                              function: (){
                                Navigator.push(context,
                                  MaterialPageRoute(builder: (context)=> Men()),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16,),
              Container(
                child: Column(
                  children: <Widget>[
                    Container(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 4,right: 10),
                        child: Text("باكدج",style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,color: Colors.grey.shade700,
                        ),textAlign: TextAlign.right,),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(8),
                      child: PackagePage(
                        packages: packages,
                        context: context,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
