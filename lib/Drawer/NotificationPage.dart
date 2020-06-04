import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import '../Addition Helper/WidowsHelper.dart';
import 'package:flutter/material.dart';
import '../main.dart';

class NotificationPage extends StatefulWidget {
  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {

  List notificationData;

  Future<void> getNotificationData()async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');
    try{
      var response = await http.get(
          getUrl("/api/getNotification"),
          headers: {
            "Accept" : "application/json",
            "Authorization" : "Bearer $token"
          }
      );
      if(response.statusCode == 200 || response.statusCode == 201){
        print(response.body);

        var decoded = jsonDecode(response.body);
        print(">>>>>>>>>>>>>>>>: ${decoded["data"].length}");
        setState(() {
          notificationData = decoded["data"];
        });
        print("<<<<<<<<<<<<<<<<: ${notificationData.length}");


      }else{
        setState(() {
          showCustomDialog(context, "حدث خطأ في الاتصال");
        });
      }
    }catch(e){}
  }

  @override
  void initState() {
    super.initState();

    getNotificationData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: <Widget>[
            SizedBox(width: 8,),
            Text("Notifications",style: TextStyle(color: Colors.teal),),
          ],
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back,color: Colors.black87,size: 33,),
          onPressed: ()=>Navigator.pop(context)),
        actions: <Widget>[
        ],
        centerTitle: true,
        backgroundColor: Colors.grey.shade100,
      ),

    body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Colors.grey.shade300,
        child: Container(
          child: notificationData==null?
          Container(
            child: Center(child: CircularProgressIndicator(),),
          ):notificationData.length==0?
          Container(
            child: Center(
              child: Text("لا يوجد لديك اشعارات"),
            ),
          ):Container(
            padding: EdgeInsets.all(4),
            child: ListView(

                scrollDirection: Axis.vertical,
                children: notificationData.map((notify){
                  return Container(
                    padding: EdgeInsets.only(left: 8,right: 8,top: 6,bottom: 6),
                    width: MediaQuery.of(context).size.width,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: Container(
                          color: Colors.white,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              SizedBox(height: 10,),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  Text(notify["title"],
                                    style: TextStyle(fontSize: 16,),),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 16,left: 8),
                                    child: Text(":اسم الصيدلية",style: TextStyle(fontSize: 18,
                                        color: Colors.teal.shade500,fontWeight: FontWeight.bold),),
                                  ),
                                ],
                              ),

                              SizedBox(height: 10,),
                              new Divider(color: Colors.grey.shade700),
                              SizedBox(height: 10,),
//                        Row(
//                          crossAxisAlignment: CrossAxisAlignment.center,
//                          mainAxisAlignment: MainAxisAlignment.end,
//                          children: <Widget>[
//                            Text(notificationData[index]["price"].toString(),
//                              style: TextStyle(fontSize: 16,),),
//                            Padding(
//                              padding: const EdgeInsets.only(left: 8,right: 10),
//                              child: Text(":سعر الطلب",style: TextStyle(fontSize: 18,
//                              color: Colors.teal.shade500,fontWeight: FontWeight.bold),),
//                            ),
//
//
//                            Text(savedNotificationData[index]["time"].toString(),
//                              style: TextStyle(fontSize: 16,),),
//                            Padding(
//                              padding: const EdgeInsets.only(right: 16,left: 8),
//                              child: Text(":وقت الوصول",style: TextStyle(fontSize: 18,
//                                  color: Colors.teal.shade500,fontWeight: FontWeight.bold),),
//                            ),
//                          ],
//                        ),
//
//                        new Divider(color: Colors.grey.shade700,height: 2,),

                              Container(
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(12),
                                    child: Text(notify["body"],
                                      style: TextStyle(fontSize: 16,),),
                                  ),
                                ),
                              ),
                              SizedBox(height: 10,),
                            ],
                          )
                      ),
                    ),
                  );
                }).toList(),
            ),

          )
        )
      ),
    );
  }
}
