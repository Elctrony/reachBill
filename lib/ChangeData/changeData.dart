import 'package:flutter/material.dart';
import './changePass.dart';
import './changeImage.dart';
import './changeUserInfo.dart';

class changeData extends StatefulWidget {
  @override
  _changeDataState createState() => _changeDataState();
}
class _changeDataState extends State<changeData> {

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: new AppBar(
          centerTitle: false,
          leading: IconButton(
            icon: Icon(Icons.arrow_back,size: 33,),
            onPressed: (){
              Navigator.pop(context);
              Navigator.pop(context);
            },
            color: Colors.teal,
          ),
          backgroundColor: Colors.grey.shade50,
          title: Container(
            padding: EdgeInsets.only(right: 16),
            alignment: Alignment.centerRight,
            child: Text(
              "تغيير البيانات",
              style: TextStyle(color: Colors.teal.shade700, fontSize: 22,
                  fontWeight: FontWeight.bold),
            ),
          ),
          bottom: TabBar(
            labelColor: Colors.teal.shade600,
            labelStyle: TextStyle(fontSize: 11,fontWeight: FontWeight.bold,),
            labelPadding: EdgeInsets.all(0),
            unselectedLabelColor: Colors.black38,
            indicatorColor: Colors.teal,
            tabs: [
              Tab(
                text: "الصورة الشخصية",
              ),
              Tab(
                text: "كلمة المرور",
              ),
              Tab(
                text: "المعلومات الاساسية",
              ),
            ]
          ),
        ),
        body: TabBarView(
          children: <Widget>[

            changeImage(_scaffoldKey),

            changePass(_scaffoldKey),

            changeUserInfo(_scaffoldKey),

          ],
        ),
      ),
    );
  }
}
