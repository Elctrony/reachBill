import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async';
import '../main.dart';

class AlarmCalenderPage extends StatelessWidget {

  _addToAlarm({@required String title,@required String description,
    @required DateTime startDate,@required DateTime endDate}){
    var event = Event(
        title: title,
        description: description,
        location: ' ',
        startDate: startDate,
        endDate: endDate,
        allDay: true
    );
    Add2Calendar.addEvent2Cal(event);
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  Future _getAlarmData()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');
    try{
      var response = await http.get(
          getUrl("/api/getalarm"),
          headers: {
            "Accept" : "application/json",
            "Authorization" : "Bearer $token"
          }
      );

      if(response.statusCode == 200 || response.statusCode == 201){
        return jsonDecode(response.body);
      }else{
        return response;
      }
    }catch(e){}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Row(
          children: <Widget>[
            SizedBox(width: 8,),
            Text("Alarm Calender",style: TextStyle(color: Colors.teal),),
          ],
        ),
        leading: IconButton(
            icon: Icon(Icons.arrow_back,color: Colors.black87,size: 33,),
            onPressed: ()=>Navigator.pop(context)),
        centerTitle: true,
        backgroundColor: Colors.grey.shade100,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Colors.grey.shade300,

        child: FutureBuilder(
          future: _getAlarmData(),
          builder: (BuildContext context,AsyncSnapshot snapshot){
            if(snapshot.connectionState == ConnectionState.done){
              if(snapshot.data!=null){
                var dataFromApi = snapshot.data;
                return ListView.builder(
                  itemCount: dataFromApi.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        margin: EdgeInsets.all(0),
                        elevation: 5,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(right: 8,top: 8),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(dataFromApi[index]["details"]),
                              ),
                            ),
                            dataFromApi[index]["dates"]!=null?Divider(
                              color: Colors.black,height: 0,indent: 2,):Container(),
                            dataFromApi[index]["dates"]!=null?ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: dataFromApi[index]["dates"].length,
                              itemBuilder: (context, i) {
                                return Column(
                                  children: <Widget>[
                                    Container(
                                      color: i%2==0?Colors.grey.shade100:Colors.white10,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.only(bottom: 8,top: 8),
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.circular(4),
                                              child: RaisedButton.icon(
                                                icon: Icon(Icons.arrow_back_ios,
                                                  size: 30,color: Colors.white,),
                                                onPressed: (){
                                                  _addToAlarm(
                                                    title: "تذكير بموعد الدواء",
                                                    description: dataFromApi[index]["details"],
                                                    startDate: DateTime.now(),
                                                    endDate: DateTime.now().add(
                                                        Duration(days: 7)),
                                                  );
                                                },
                                                label: Text("اضف الي \n التقويم",style:
                                                TextStyle(color: Colors.white,),),
                                                color: Colors.teal,
                                                elevation: 5,
                                              ),
                                            ),
                                          ),
                                          Text("الدواء كل :${dataFromApi[index]["dates"][i]["time"]}"),
                                          Text(dataFromApi[index]["dates"][i]["name"],),
                                        ],
                                      ),
                                    ),
                                    i+1!=dataFromApi[index]["dates"].length?Divider(height: 0,):Container(),
                                  ],
                                );
                              }
                            ):SizedBox(height: 1),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }else{
                return Text("No Data Found!");
              }
            }else{
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }
}
