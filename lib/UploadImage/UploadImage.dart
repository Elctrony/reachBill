
import 'dart:io';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:http/http.dart'as http;
import 'package:async/async.dart';
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart'as path;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../main.dart';

Future<List> uploadingImages(List<File> mySelectedImages) async {

  SharedPreferences prefs = await SharedPreferences.getInstance();
  String token = prefs.getString('token');

  List imageNameFromServer=[];
  debugPrint("><><><><><>><><><><><><>:"+mySelectedImages.length.toString());

  for(int i=0;i<mySelectedImages.length;i++){
    File imageFile = mySelectedImages[i];

    var stream = new http.ByteStream(DelegatingStream.typed(
        imageFile.openRead()));
    var length = await imageFile.length();

    var uri = Uri.parse(getUrl("/api/upload"));

    var request = new http.MultipartRequest("POST", uri);
    var multipartFile = new http.MultipartFile('image[]', stream, length,
        filename: basename(imageFile.path),
        contentType: new MediaType('image', 'png'));

    request.files.add(multipartFile);
    request.headers.addAll({
      "Accept" : "application/json",
      "Authorization" : "Bearer $token"
    });
    var response = await request.send();
    print(response.statusCode);

    response.stream.transform(utf8.decoder).listen((value) {
      imageNameFromServer.insert(i,jsonDecode(value)["images"][0]);
    });

  }
  await Future.delayed(const Duration(milliseconds: 1000), () {
    debugPrint("><><><><><>><><><><><><>:"+imageNameFromServer.length.toString());
  });
  return imageNameFromServer;
}
