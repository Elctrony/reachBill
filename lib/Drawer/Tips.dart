import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async';
import '../main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../RegistrationAndLogIn/InputDesign.dart';
import '../Addition Helper/WidowsHelper.dart';

class ShowTips extends StatefulWidget {

  @override
  _ShowTipsState createState() => _ShowTipsState();
}

class _ShowTipsState extends State<ShowTips> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  List dataFromApi;

  Future _getTips()async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');
    try{
      var response = await http.get(
          getUrl("/api/tips"),
          headers: {
            "Accept" : "application/json",
            "Authorization" : "Bearer $token"
          }
      );
      print(response.body);
      if(response.statusCode == 200 || response.statusCode == 201){
        setState(() {
          dataFromApi = jsonDecode(response.body);
        });
      }else{

      }
      print(response.body);
    }catch(e){}
  }

  @override
  void initState() {
    super.initState();
    _getTips();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        title: Text("النصائح",style: TextStyle(color: Colors.teal,
            fontWeight: FontWeight.bold),),
        centerTitle: true,
        backgroundColor: Colors.grey.shade100,
        leading: IconButton(
          icon: Icon(Icons.arrow_back,size: 30,color: Colors.teal,),
          onPressed: (){
            Navigator.pop(context);
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(4),
        color: Colors.grey.shade200,
        child: Column(
          children: <Widget>[
            Expanded(
              child: Container(
                width: MediaQuery.of(context).size.width,
                color: Colors.grey.shade200,
                child: Center(
                  child: dataFromApi==null?CircularProgressIndicator():dataFromApi.length==0?
                  Center(
                    child: Text("لا توجد نصائح",style: TextStyle(color: Colors.teal,
                    fontWeight: FontWeight.bold),),
                  ):ListView(
                    children: <Widget>[
                      Container(
                        child: GridView.builder(
                          shrinkWrap: true,
                          physics: ScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: MediaQuery.of(context).size.width,
                            childAspectRatio: 7/4,
                          ),
                          padding: const EdgeInsets.all(5.0),
                          itemCount:dataFromApi.length,
                          itemBuilder: (BuildContext context , int i){
                            return Padding(
                              padding: const EdgeInsets.only(top: 12),
                              child: Container(
                                child: Card(
                                  margin: EdgeInsets.all(0),
                                  elevation: 5,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.only(right: 12,top: 3,bottom: 3),
                                        child: Text(dataFromApi[i]["title"],
                                          style: TextStyle(fontSize: 16, color:
                                          Colors.teal,fontWeight: FontWeight.bold),),
                                      ),

                                      new Divider(color: Colors.grey.shade700,height: 1,),

                                      Padding(
                                        padding: const EdgeInsets.all(4.0),
                                          child: Text(dataFromApi[i]["body"],
                                          style: TextStyle(fontSize: 16,
                                              color: Colors.teal.shade900),overflow:
                                          TextOverflow.ellipsis,maxLines: 5,),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
