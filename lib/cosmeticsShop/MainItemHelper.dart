import 'package:flutter/material.dart';
import './ShowTheSpecificMainItem.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async';
import '../main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainItems extends StatefulWidget {
  int categoryId;
  MainItems({this.categoryId});

  @override
  _MainItemsState createState() => _MainItemsState(
      categoryId: categoryId);
}
class _MainItemsState extends State<MainItems> {

  _MainItemsState({this.categoryId});

  int categoryId;
  getGroups()async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');
    try{
      var response = await http.get(
          getUrl("/api/getgroup/$categoryId"),
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
  List dataFromApi;

  @override
  void initState() {
    super.initState();
    getGroups();
  }

  forwardToPage(String title,int groupId,BuildContext context){
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context)=>
          ShowItem(title: title,groupId: groupId))
    );
  }
  Widget showContainer(){
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height-200,
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
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        dataFromApi==null?showContainer():
        dataFromApi.length==0?Container(height: MediaQuery.of(context).size.height-200,
          child: Center(child: Text(
          'لا يوجد عناصر',style: TextStyle(color: Colors.teal,fontSize: 18),),),):
        GridView.builder(
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: MediaQuery.of(context).size.width/2,
            childAspectRatio: 5/4,
          ),
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          scrollDirection: Axis.vertical,
          itemCount: dataFromApi.length,
          itemBuilder: (BuildContext context,int i){
            return Container(
              child: InkWell(
                onTap: (){
                  forwardToPage(dataFromApi[i]["name"],dataFromApi[i]["id"],context);
                },
                child: Container(
                  height: 100,
                  width: MediaQuery.of(context).size.width/2-20,
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.5),
                        ),
                        child: Container(
                          child: Center(
                              child: Text(dataFromApi[i]["name"],style: TextStyle(
                                color: Colors.grey.shade700,
                              ),)
                          )
                        )
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}