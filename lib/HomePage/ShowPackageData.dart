import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './showListOfItems.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async';
import '../main.dart';
import '../Addition Helper/WidowsHelper.dart';
import 'package:auto_size_text/auto_size_text.dart';


class ShowPackageData extends StatefulWidget {

  String url;

  ShowPackageData({this.url});

  @override
  _ShowPackageDataState createState() => _ShowPackageDataState();
}

class _ShowPackageDataState extends State<ShowPackageData> {

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  Map<String, dynamic> dataFromApi;

  String packageId = "";
  String packageName = "تحميل";
  String packagePrice = "0.0";
  String imageUrl = "";
  String imageName = "";
  List packageContent = [];

  _ShowPackageDataState(){
    getPackageData();
  }
  Future getPackageData()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');
    try{
      var response = await http.get(
          widget.url,
          headers: {
            "Accept" : "application/json",
            "Authorization" : "Bearer $token"
          }
      );
      print(response.statusCode);
      print(response.body);
      _scaffoldKey.currentState.removeCurrentSnackBar();
      dataFromApi = jsonDecode(response.body);
      setState(() {
        packageId = dataFromApi["id"].toString();
        packageName = dataFromApi["name"];
        packagePrice = dataFromApi["price"].toString();
        imageUrl = getUrl("/images/${dataFromApi["image"]}");
        imageName = dataFromApi["image"];
        packageContent = dataFromApi["cosmetics"];
      });
    }catch(e){print(e.toString());}
  }

  Future addToCart()async{
    showSnackBar(context, "يتم اضافة الباكيدج يرجي الانتظار",scaffoldKey: _scaffoldKey);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');
    try{
      var response = await http.post(
          getUrl("/api/addproduct"),
          body: {
            "data" : packageName,
            "image" : imageName,
            "type" : "package",
            "count" : "1",
            "price" : packagePrice,
            "product_id" : packageId,
          },
          headers: {
            "Accept" : "application/json",
            "Authorization" : "Bearer $token"
          }
      );
      print("add to cart: "+response.statusCode.toString());

      if(jsonDecode(response.body)["status"].toString()=="true"){

        _scaffoldKey.currentState.removeCurrentSnackBar();
        showCustomDialog(context, "تم اضافة الباكيدج الي العربة",
            function: ()=> Navigator.pop(context));
      }
    }catch(e){print(e.toString());}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.grey.shade100,
        leading: IconButton(
          icon: Icon(Icons.arrow_back,size: 30,color: Colors.black,),
          onPressed: ()=>Navigator.pop(context),
        ),
        title: Container(
          alignment: Alignment.centerRight,
          child: Text("Package",style: TextStyle(
              color: Colors.teal.shade600,fontSize: 16,fontWeight: FontWeight.w700
          ),textAlign: TextAlign.right,),
        ), //centerTitle: true,
      ),
      body: ListView(
        children: <Widget>[
          Container(
            color: Colors.grey.shade200,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Card(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.all(2),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: Image(
                              image: imageUrl.length<5?AssetImage("images/loading.gif",):
                              NetworkImage(imageUrl,scale: 1),
                              width: MediaQuery.of(context).size.width/2-30,
                              height: 120,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[

                            Container(
                              width: MediaQuery.of(context).size.width/2-5,
                              padding: EdgeInsets.only(right: 5),
                              alignment: Alignment.centerRight,
                              child: AutoSizeText(
                                packageName,style: TextStyle(
                                  color: Colors.teal.shade800,
                                  fontWeight: FontWeight.w600,fontSize: 20),
                                minFontSize: 12,maxFontSize: 20,
                                maxLines: 2,
                                overflow: TextOverflow.clip,
                                textDirection: TextDirection.rtl,
                              ),
                            ),
                            Divider(),
                            Container(
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.only(right: 5,bottom: 5),
                              child: Text(" السعر : $packagePrice", style:
                              TextStyle(fontSize: 18,color: Colors.teal.shade800,
                                  fontWeight: FontWeight.w600),),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 16,bottom: 8,top: 8),
                  child: Text("المحتوي",style: TextStyle(fontSize: 18),),
                ),
                ShowListOfItems(dataFromApi: packageContent,),

                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.all(14),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: RaisedButton(
                      color: Colors.teal.shade700,
                      padding: EdgeInsets.all(8),
                      onPressed: (){
                        if(userToken!=null) {
                          if (dataFromApi != null) {
                            addToCart();
                          } else {
                            showSnackBar(context, "يرجي الانتظار",
                                scaffoldKey: _scaffoldKey);
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}
