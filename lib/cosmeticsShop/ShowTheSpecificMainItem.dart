import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async';
import '../main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Addition Helper/WidowsHelper.dart';

class ShowItem extends StatefulWidget {

  String title;
  int groupId;
  ShowItem({this.title,this.groupId});

  @override
  _ShowItemState createState() => _ShowItemState();
}

class _ShowItemState extends State<ShowItem> {

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  TextEditingController searchController = TextEditingController();
  List dataFromApi;

  getCosmetics()async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');
    try{
      var response = await http.get(
          getUrl("/api/getcosmetic/${widget.groupId}"),
          headers: {
            "Accept" : "application/json",
            "Authorization" : "Bearer $token"
          }
      );
      if(jsonDecode(response.body) != null){
        setState(() {
          dataFromApi = jsonDecode(response.body);
        });
      }else {
        setState(() {
          dataFromApi = [];
        });
      }
    }catch(exception){print(exception);}
  }

  Future addToCart({String packageName,String imageName,String packagePrice,
    String packageId})async{

    showSnackBar(context, "يتم اضافه العنصر الي العربة",
        scaffoldKey: _scaffoldKey);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');
    try{
      var response = await http.post(
          getUrl("/api/addproduct"),
          body: {
            "data" : packageName,
            "image" : imageName,
            "type" : "cosmetic",
            "count" : "1",
            "price" : packagePrice,
            "product_id" : packageId,
          },
          headers: {
            "Accept" : "application/json",
            "Authorization" : "Bearer $token"
          }
      );
      if(jsonDecode(response.body)["status"].toString()=="true"){
        _scaffoldKey.currentState.removeCurrentSnackBar();
        showCustomDialog(context, "تم اضافة العنصر الي العربة");
      }
    }catch(e){print(e.toString());}
  }

  Container myContainer = new Container();
  Widget showContainer(){
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height-300,
      child: Center(
        child: Container(
            width: 50,
            height: 50,
            child: CircularProgressIndicator()
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    getCosmetics();
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
          child: Text(widget.title,style: TextStyle(
              color: Colors.teal.shade600,fontSize: 16,fontWeight: FontWeight.w700
          ),textAlign: TextAlign.right,),
        ), //centerTitle: true,
      ),

      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Colors.grey.shade200,
        child: ListView(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(8),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(7),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: TextFormField(
                    textDirection: TextDirection.rtl,
                    textAlign: TextAlign.right,
                    controller: searchController,
                    decoration: InputDecoration(
                        prefixIcon: IconButton(
                            icon: Icon(Icons.search,size: 30,color: Colors.black54,),
                            onPressed: (){
                              print("search pressed");
                            }
                        ),
                        border: InputBorder.none,
                        //filled: true,
                        hintText: "بحث",
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 13),
                        fillColor:Colors.white,alignLabelWithHint: true
                    ),
                    textCapitalization: TextCapitalization.words,
                    maxLines: 1,
                    keyboardType: TextInputType.text,
                    style: TextStyle(fontSize: 15,
                        color: Colors.black54),
                  ),
                ),
              ),
            ),
            dataFromApi == null? showContainer():
            Container(
              padding: EdgeInsets.all(4),
              child: GridView.builder(
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: MediaQuery.of(context).size.width,
                childAspectRatio: 3/1,
              ),
              shrinkWrap: true,
              physics: ScrollPhysics(),
              scrollDirection: Axis.vertical,
              itemCount: dataFromApi.length,
                itemBuilder: (BuildContext context, int index) {
                return Container(
                  padding: EdgeInsets.only(left: 8,right: 8,top: 6,bottom: 6),
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        flex: 4,
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
                                  child: Container(
                                    alignment: Alignment.centerRight,
                                    padding: EdgeInsets.only(right: 8),
                                    child: Text(dataFromApi[index]["name"],
                                      style: TextStyle(color: Colors.teal.shade700,fontSize: 22),
                                      textAlign: TextAlign.right,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    alignment: Alignment.centerRight,
                                    padding: EdgeInsets.only(right: 8),
                                    child: Text(dataFromApi[index]["description"],
                                      style: TextStyle(color: Colors.teal,fontSize: 18),
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
                                            child: IconButton(
                                              icon: Icon(Icons.add_shopping_cart,
                                                color: Colors.teal,size: 25,),
                                              onPressed: (){
                                                if(userToken!=null)
                                                addToCart(
                                                  imageName: dataFromApi[index]["image"],
                                                  packageId: dataFromApi[index]["id"].toString(),
                                                  packageName: dataFromApi[index]["name"],
                                                  packagePrice: dataFromApi[index]["price"].toString(),
                                                );
                                                else showLoginDialog(context);
                                              },
                                            ),
                                          ),
                                        ),
                                        Container(
                                          alignment: Alignment.centerRight,
                                          padding: EdgeInsets.only(right: 8),
                                          child: Text(" ${dataFromApi[index]["price"]} LE",
                                            style: TextStyle(color: Colors.teal,
                                                fontSize: 16),
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
                        flex: 2,
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
                          child: Container(
                            child: ClipRRect(
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(0),
                                topLeft: Radius.circular(0),
                                bottomRight: Radius.circular(7),
                                topRight: Radius.circular(7),
                              ),
                              child: Image(image: NetworkImage(
                                getUrl("/images/${dataFromApi[index]["image"]}"),
                                scale: 1,),fit: BoxFit.cover,width: 220,height: 220,),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                );
              }
              ),
            ),
          ],
        ),
      ),
    );
  }
}
