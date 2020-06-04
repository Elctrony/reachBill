import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart' as prefix0;
import 'package:online_pharmacy/Addition%20Helper/CartTotalPrice.dart';
import 'package:provider/provider.dart';
import 'package:splashscreen/splashscreen.dart';
import './RegistrationAndLogIn/LogIn.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './HomePage/HomePage.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import './Addition Helper/WidowsHelper.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import './Drawer/NotificationPage.dart';

String userToken = null;
void main()async{

  SharedPreferences prefs = await SharedPreferences.getInstance();
   userToken = prefs.getString('token');

  runApp(
      stateBetween(userToken)
  );
}

class stateBetween extends StatelessWidget {

  String userToken;
  stateBetween(this.userToken);
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<TotalPriceValue>(
      builder: (context)=> TotalPriceValue(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Reach Pill",
        home:MyApp(userToken),
          routes: <String, WidgetBuilder>{
            '/logIn' : (BuildContext context) => LogIn(),
            '/homepage' : (BuildContext context) => HomePage(),
          }
      ),
    );
  }
}




class MyApp extends StatefulWidget {

  String userToken;
  MyApp(this.userToken);

  @override
  _MyAppState createState() => _MyAppState(userToken);
}

class _MyAppState extends State<MyApp> {

  String userToken;
  _MyAppState(this.userToken);

  //===================================================================================

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  Future onSelectNotification(String payload) async {
    if (payload != null) {
      debugPrint('notification payload: ' + payload);
    }
    Navigator.push(context,
      MaterialPageRoute(builder: (context)=> NotificationPage()),
    );
  }
  Future showNotification({int id, String title,String body})async{
    var android = AndroidNotificationDetails(
        'your channel id', 'your channel name', 'your channel description',
        importance: Importance.Max, priority: Priority.High, ticker: 'ticker');

    var ios = IOSNotificationDetails();

    var platformChannelSpecifics = NotificationDetails(
        android, ios);

    await flutterLocalNotificationsPlugin.show(
        0, title, body, platformChannelSpecifics,
        payload: 'item x');
  }
//=========================================================================
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  @override
  void initState() {
    super.initState();
    firebaseCloudMessagingListeners();

    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();

    var android = AndroidInitializationSettings('@mipmap/ic_launcher');
    var ios = IOSInitializationSettings();

    var initializationSettings = new InitializationSettings(
        android, ios);
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
  }

  void firebaseCloudMessagingListeners() async{
    if (Platform.isIOS) iOS_Permission();

    SharedPreferences prefs = await SharedPreferences.getInstance();

    if(prefs.getString("device_token")==null){
      _firebaseMessaging.getToken().then((token){
        prefs.setString("device_token", token);
        print("device token: "+token);
      });
    }

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print('on message $message');
        prefs.setBool("notification", true);

        showNotification(
          id: 0,
          title: message["notification"]["title"],
          body: message["notification"]["body"],
        );

      },
      onResume: (Map<String, dynamic> message) async {
        print('on resume $message');
        prefs.setBool("notification", true);
      },
      onLaunch: (Map<String, dynamic> message) async {
        print('on launch $message');
        prefs.setBool("notification", true);
      },
    );
    _firebaseMessaging.requestNotificationPermissions(
      const IosNotificationSettings(
        alert: true,
        badge: true,
        sound: true
      ),
    );
    _firebaseMessaging.onIosSettingsRegistered.listen(
            (IosNotificationSettings settings){

    });
  }

  void iOS_Permission() {
    _firebaseMessaging.requestNotificationPermissions(
        IosNotificationSettings(sound: true, badge: true, alert: true)
    );
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings)
    {
      print("Settings registered: $settings");
    });
  }

  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      gradientBackground: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Colors.cyan,Colors.teal,Colors.teal.shade900],
      ),
      imageBackground: AssetImage('images/splashImage.png'),
      seconds: 3,
      navigateAfterSeconds:/*userToken!=null?*/HomePage()/*:LogIn()*/,
      loadingText: new Text(
        'Reach Pill App',
        style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0,
            color: Colors.white),
      ),
      backgroundColor: Colors.white,
      styleTextUnderTheLoader: new TextStyle(),
      onClick: () => print("Hello"),
      loaderColor: Colors.cyan,
    );
  }
}


String getUrl(String partUrl){
  //String globalUrl = "http://test.nazeehapps.com";
  //String globalUrl = "https://api.reachpill.com";
  String globalUrl = "https://back.reachpill.com";
  String result = (globalUrl+partUrl).replaceAll(" ", "");
  return result;
}



