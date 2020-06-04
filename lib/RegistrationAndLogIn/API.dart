import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async';
import '../main.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';


Future registrationRequest({String email,String password,
  String conPassword, String name, String address, String phone, String dOfB,
  String photo ,List<String> disease,String gender,Function callBack,
  Function rejectCallBack,double lat,double lng})async {

  var jsonMap = {
    'email': email,
    'password': password,
    'password_confirmation': conPassword,
    'name': name,
    'address': address,
    'lat': lat.toString(),
    'lng': lng.toString(),
    'phone': phone,
    'gender': gender,
    'dob': dOfB,
    'disease': json.encode(disease),
    'photo': photo,
  };

  try{
    var response = await http.post(
        getUrl("/api/register"),
        body:jsonMap,
        headers: {
          "Accept" : "application/json",
        }
    );
    if(response.statusCode == 200||response.statusCode == 201){
      callBack();
    }else{
      Map<String, dynamic> responseData = jsonDecode(response.body);
      String errorMessage = "";
      if(responseData['errors'].toString().indexOf("password") >=0)
        errorMessage = "برجاء التأكد من تطابق كلمات السر";
      else if(responseData['errors'].toString().indexOf("phone") >=0)
        errorMessage = "رقم الهاتف الذي ادخلته موجود بالفعل";
      else if(responseData['errors'].toString().indexOf("email") >=0)
        errorMessage = "البريد الإلكتروني الذي ادخلته موجود بالفعل";
      else
        errorMessage = "برجاء التأكد من املاء جميع الخانات المطلوبه";

      rejectCallBack(errorMessage);
    }
    print('Response status: ${response.body}');
  }catch(exception){print(exception);}
}


Future logInRequest({String email,String password,
  Function callBack,Function rejectCallBack})async {

  SharedPreferences prefs = await SharedPreferences.getInstance();
  String deviceToken = prefs.get('device_token');

  try {
    final result = await InternetAddress.lookup('google.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {

      var jsonMap = {
        'email': email,
        'password': password,
        'token': deviceToken
      };
      try{
        var response = await http.post(
            getUrl("/api/login"),
            body:jsonMap,
            headers: {
              "Accept" : "application/json",
            }
        );
        print(response.body);
        if(response.statusCode == 200){
          await saveToken(jsonDecode(response.body)["token"]).then((state){
            if(state){
              callBack();
            }
            else {
              rejectCallBack();
            }
          });
        }else {
          rejectCallBack();
          await clearShard();
        }
        print('Response body: ${response.body}');

      }catch(exception){print(exception);}

    }
  } on SocketException catch (_) {
    rejectCallBack();
  }
}

Future<bool> saveToken(String token) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('token', token );
  userToken = token;
  try{
    var response = await http.get(
        getUrl("/api/user"),
        headers: {
          "Accept" : "application/json",
          "Authorization" : "Bearer $token"
        }
    );
    if(response.statusCode == 200 || response.statusCode == 201){
      prefs.setDouble("lat", double.parse(jsonDecode(response.body)["lat"]));
      prefs.setDouble("lng", double.parse(jsonDecode(response.body)["lng"]));
      prefs.setString("phone", jsonDecode(response.body)["phone"]);
      prefs.setString("name", jsonDecode(response.body)["name"]);
      prefs.setString("photo", jsonDecode(response.body)["photo"]);
      prefs.setString("address", jsonDecode(response.body)["address"]);
    }
    print('person data : ${response.body}');

    if(jsonDecode(response.body)["role"].toString() == "user") return true;

  }catch(exception){print(exception);}
  return false;
}
Future clearShard()async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.clear();
}


/*
  HttpClient httpClient = new HttpClient();
  HttpClientRequest request = await httpClient.postUrl(Uri.parse(getUrl("/api/register")));
  request.headers.set('content-type', 'application/json');
  request.headers.set('Accept' , 'application/json');
  request.add(utf8.encode(json.encode(jsonMap)));
  HttpClientResponse response = await request.close();

  String reply = await response.transform(utf8.decoder).join();
  httpClient.close();

  print('Response status: ${response.statusCode}');
  */