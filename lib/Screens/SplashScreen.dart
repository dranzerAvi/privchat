import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:privchat/Screens/MainScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Classes/Constants.dart';
import 'ChatScreen.dart';
import 'SignInScreen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  DatabaseReference dbRef = FirebaseDatabase.instance.reference();

  // Future<String> _getId() async {
  //   DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  //   if (Theme.of(context).platform == TargetPlatform.iOS) {
  //     IosDeviceInfo iosDeviceInfo = await deviceInfo.iosInfo;
  //     return iosDeviceInfo.identifierForVendor; // unique ID on iOS
  //   } else {
  //     AndroidDeviceInfo androidDeviceInfo = await deviceInfo.androidInfo;
  //     return androidDeviceInfo.androidId; // unique ID on Android
  //   }
  // }

  String deviceId = '';

  void setId() async {
    // deviceId = await _getId();
    setState(() {
      print("UID IS $deviceId");
    });
    getDatabaseRef();
  }

  String enroll = '';
  int sem;
  bool isStored;

  getDatabaseRef() async {
    DatabaseReference userref = FirebaseDatabase.instance
        .reference()
        .child('Users')
        .child('u$deviceId');
    print('Unique Id is u$deviceId');
    await userref.once().then((DataSnapshot snap) async {
      print('Snap value is ${snap.value}');
      if (snap.value == null) {
        isStored = false;
        print('Is stored? $isStored');
      } else {
        isStored = true;
        enroll = await snap.value['enroll'];
        sem = await snap.value['sem'];
        print('Enrollment is $enroll');
        setState(() {
          print(enroll);
          print(sem);
          print('Is it stored? $isStored');
        });
      }
    });

    if (!isStored) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ChatScreen('name')),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ChatScreen('name'),
        ),
      );
    }
  }

  @override
  // ignore: must_call_super
  void initState() {
    new Future.delayed(Duration(seconds: 3), () async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String user = prefs.getString('name');
      if (user == null || user.length == 0)
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => SignIn(),
          ),
        );
      else
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => MainScreen(),
          ),
        );
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: darkColor,
      body: Center(
        child: InkWell(
          onTap: () {
            setId();
          },
          child: Image.asset(
            'assets/images/sc logo.png',
            height: height * 0.4,
          ),
        ),
      ),
    );
  }
}
