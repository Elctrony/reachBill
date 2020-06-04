import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:http/http.dart'as http;
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'package:online_pharmacy/UploadImage/UploadImage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Addition Helper/WidowsHelper.dart';
import '../main.dart';


// ignore: camel_case_types
class changeImage extends StatefulWidget {
  GlobalKey<ScaffoldState> _scaffoldKey;
  changeImage(this._scaffoldKey);
  @override
  _changeImageState createState() => _changeImageState(_scaffoldKey);
}

// ignore: camel_case_types
class _changeImageState extends State<changeImage> {

  GlobalKey<ScaffoldState> _scaffoldKey;
  _changeImageState(this._scaffoldKey);

  String savedImage;
  File _image;
  Future _getImageFromGallery() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
    });
  }

  Future _getImageFromCamera() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      _image = image;
    });
  }

  Future _savePressed()async{

    List imageFromServer = await uploadingImages([_image]);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');

    try{
      var response = await http.post(
        getUrl("/api/updatedata"),
        body: {
          "photo" : imageFromServer.length>0?"${imageFromServer[0]}":"",
        },
        headers: {
          "Accept" : "application/json",
          "Authorization" : "Bearer $token"
        }
      );
      print("change user picture: "+response.body);
      if(response.statusCode == 200 || response.statusCode == 201){
        showCustomDialog(context, "تم تغيير الصورة الشخصية بنجاح");
        String newPicture = jsonDecode(response.body)["data"]["photo"];
        print(newPicture);
        prefs.setString("photo", newPicture.replaceAll("\"", "").toString());

      }
    }catch(exception){print(exception);}
    showContainer(false);

  }

  Future _cancelPressed()async{
    setState(() {
      _image  = null;
    });
  }

  Future _getImage()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      savedImage =prefs.getString("photo");
    });
    print(getUrl("/images/"+savedImage));
  }



  @override
  initState(){
    super.initState();
    _getImage();
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
        ListView(
          children: <Widget>[
            Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(6),
                child: Card(
                  color: Colors.grey.shade200,
                  shape: RoundedRectangleBorder(

                    borderRadius: BorderRadius.circular(6),
                    side: BorderSide(color: Colors.grey.shade300),
                  ),
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Text(
                          "الصورة الشخصية", style: TextStyle(
                            fontSize: 18,color: Colors.teal,fontWeight: FontWeight.bold),
                        ),
                      ),
                      _image==null?Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child:InkWell(
                          onTap: (){},
                          child: Container(
                            alignment: Alignment.centerLeft,
                            width: 200.0,
                            height: 200.0,
                            decoration: new BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              shape: BoxShape.circle,
                              image: new DecorationImage(
                                fit: BoxFit.cover,
                                image:savedImage==null?AssetImage("images/user.png"):
                                    NetworkImage(getUrl("/images/$savedImage"),scale: 1.0),
                              ),
                            ),
                          ),
                        ),
                      ):InkWell(
                        onTap: (){},
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                            child: Image.file(
                              _image,fit: BoxFit.cover,height: 200,width: 200,
                            )
                        ),
                      ),
                      SizedBox(height: 16,),

                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[

                            Expanded(
                              child: Container(
                                height: 50,
                                padding: EdgeInsets.only(left: 8,right: 4),
                                child: RaisedButton(
                                  elevation: 5,
                                  onPressed: _getImageFromGallery,
                                  color: Colors.white,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(6)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text("إختر صورة",style: TextStyle(
                                        color: Colors.teal,fontWeight: FontWeight.bold),
                                    ),
                                  )
                                ),
                              ),
                            ),

                            Expanded(
                              child: Container(
                                height: 50,
                                padding: EdgeInsets.only(left: 4,right: 8),
                                child: RaisedButton(
                                  elevation: 5,
                                  onPressed: _getImageFromCamera,
                                  color: Colors.white,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(6)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text("إلتقط صورة",style: TextStyle(
                                        color: Colors.teal,fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 12,),
                      Container(
                        margin: EdgeInsets.only(top: 16),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Container(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(6),
                                    child: RaisedButton(
                                      color: Colors.teal.shade800,
                                      onPressed: (){
                                        if(_image==null){
                                          showSnackBar(context, "لم يتم اختيار صورة",
                                              scaffoldKey: _scaffoldKey);
                                        }else{
                                          showContainer(true);
                                          _savePressed();
                                        }
                                      },
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Icon(Icons.file_upload,color: Colors.white,),

                                          Text("حفظ",style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w700,height: 2),
                                          ),
                                        ],
                                      )
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Container(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(6),
                                    child: RaisedButton(
                                      color: Colors.red.shade900,
                                      onPressed: _cancelPressed,
                                      child: Text("الغاء",style: TextStyle(
                                          color: Colors.white,fontWeight: FontWeight.w700,
                                          height: 2),),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        myContainer,
      ],
    );
  }
}
