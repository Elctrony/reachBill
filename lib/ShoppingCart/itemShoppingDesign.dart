import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:online_pharmacy/Addition%20Helper/CartTotalPrice.dart';
import 'package:provider/provider.dart';
import '../main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ItemDesign extends StatefulWidget {

  String title;
  String subtitle;
  String priceItem;
  String imageUrl;
  Function deleteFunction;
  int counter;
  int productId;

  ItemDesign({this.title,this.subtitle,this.priceItem,this.imageUrl,
    this.deleteFunction,this.counter,this.productId});


  @override
  _ItemDesignState createState() => _ItemDesignState(
      title: title, imageUrl: imageUrl,priceItem: priceItem,
      subtitle: subtitle,deleteFunction: deleteFunction,
      counter: counter,productId: productId);
}

class _ItemDesignState extends State<ItemDesign> {

  _ItemDesignState({this.title,this.subtitle,this.imageUrl,this.priceItem,
    this.deleteFunction,this.counter,this.productId});

  int counter = 1;
  String title;
  String subtitle;
  String priceItem;
  String imageUrl;
  Function deleteFunction;
  int productId;


  Future updateCount()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');
    try {
      var response = await http.post(
          getUrl("/api/updateproduct"),
          body: {
            "id":"$productId",
            "count":"$counter",
          },
          headers: {
            "Accept": "application/json",
            "Authorization": "Bearer $token"
          }
      );

      var decoded = jsonDecode(response.body);

      Provider.of<TotalPriceValue>(context, listen: false)
          .setTotalPrice(decoded["price"]);

      print("update count: "+response.body);
    }catch(e){}
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 8,right: 8,top: 6,bottom: 6),
      width: MediaQuery.of(context).size.width,
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 3,
            child: Card(
              elevation: 3,
              margin: EdgeInsets.all(1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(7),
                  topLeft: Radius.circular(7),
                  bottomRight: Radius.circular(0),
                  topRight: Radius.circular(0),
                ),
              ),
              child: Container(
                child: Column(
                  children: <Widget>[
                    Expanded(
                      flex: 4,
                      child: Container(
                        child: Row(
                          children: <Widget>[
                            Expanded(child: Container(
                                child: AutoSizeText("$counter",maxFontSize: 20,minFontSize: 10,textAlign: TextAlign.center,style: TextStyle(
                                  fontSize: 20
                                ),)
                              )
                            ),
                            Expanded(
                              child: Column(
                                children: <Widget>[
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(2.0),
                                      child: RaisedButton(
                                        padding: EdgeInsets.all(1),
                                        onPressed: (){
                                          setState(() {
                                            counter++;
                                            updateCount();
                                          });
                                        },
                                        child: Icon(Icons.add,color: Colors.white,),
                                        color: Colors.green,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(2.0),
                                      child: RaisedButton(
                                        padding: EdgeInsets.all(1),
                                        onPressed: (){
                                          setState(() {
                                            if(counter>0)
                                            counter--;
                                            updateCount();
                                          });
                                        },
                                        child: Icon(Icons.remove,color: Colors.white,),
                                        color: Colors.redAccent,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(7)),
                          child: Container(
                            width: 200,
                            color: Colors.teal.shade900,
                            margin: EdgeInsets.all(0),
                            child: RaisedButton(
                              color: Colors.teal.shade900,
                              onPressed: deleteFunction,
                              textColor: Colors.white,
                              child: Text("حذف"),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            flex: 6,
            child: Card(
              elevation: 3,
              margin: EdgeInsets.all(1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(0),
                  topLeft: Radius.circular(0),
                  bottomRight: Radius.circular(0),
                  topRight: Radius.circular(0),
                ),
              ),
              child: Container(
                child: Column(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        alignment: Alignment.centerRight,
                        padding: EdgeInsets.only(right: 8),
                        child: AutoSizeText(title,maxFontSize: 22,
                          minFontSize: 8,
                          maxLines: 1,overflow: TextOverflow.clip,
                          style: TextStyle(color: Colors.teal.shade700,fontSize: 22),
                          textAlign: TextAlign.right,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        alignment: Alignment.centerRight,
                        padding: EdgeInsets.only(right: 8),
                        child: AutoSizeText(subtitle,maxFontSize:18,
                            minFontSize: 10,
                            maxLines: 1,overflow: TextOverflow.clip,
                            style: TextStyle(color: Colors.teal.shade700,fontSize: 18),
                            textAlign: TextAlign.right,
                          ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                alignment: Alignment.centerLeft,
                              ),
                            ),
                            Container(
                              alignment: Alignment.centerRight,
                              padding: EdgeInsets.only(right: 8),
                              child: AutoSizeText(priceItem,maxFontSize: 16,
                                minFontSize:10,
                                style: TextStyle(color: Colors.teal,fontSize: 16),
                                textAlign: TextAlign.right,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Card(
              elevation: 3,
              margin: EdgeInsets.all(1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(0),
                  topLeft: Radius.circular(0),
                  bottomRight: Radius.circular(7),
                  topRight: Radius.circular(7),
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(0),
                  topLeft: Radius.circular(0),
                  bottomRight: Radius.circular(7),
                  topRight: Radius.circular(7),
                ),
                child: Container(
                  child: Image(image: NetworkImage(
                    imageUrl, scale: 1,),fit: BoxFit.cover,width: 220,height: 220,),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
