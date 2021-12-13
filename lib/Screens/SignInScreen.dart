import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:privchat/Classes/Constants.dart';
import 'package:regexed_validator/regexed_validator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:steel_crypt/steel_crypt.dart';

import 'MainScreen.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  FirebaseAuth mAuth = FirebaseAuth.instance;
  TextEditingController emailC = new TextEditingController(text: '');
  TextEditingController pwC = new TextEditingController(text: '');
  TextEditingController nameC = new TextEditingController(text: '');
  String deviceUid, deviceType;

  bool isObscured = true;

  @override
  void initState() {
    isObscured = true;
    deviceUid = '';
    deviceType = '';
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final pHeight = MediaQuery.of(context).size.height;
    final pWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: darkColor,
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Container(
            width: pWidth,
            child: Stack(
              children: <Widget>[
                Positioned(
                  top: 0,
                  left: 0,
                  child: Image.asset('assets/images/Shapes.png'),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(
                          height: pHeight * 0.05,
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(
                          height: pHeight * 0.035,
                        ),
                        Text(
                          'Welcome\nBack!',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Circular',
                              fontSize: pHeight * 0.04),
                        ),
                        SizedBox(
                          height: pHeight * 0.25,
                        ),
                        Text(
                          'Sign In',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              color: txtColor,
                              fontFamily: 'Circular',
                              fontSize: pHeight * 0.035),
                        ),
                        SizedBox(
                          height: pHeight * 0.05,
                        ),
                        Container(
                          width: pWidth * 0.9,
                          decoration: BoxDecoration(
                            color: Color(0xFFE9E9E9),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: TextFormField(
                              controller: emailC,
                              validator: (value) {
                                if (!validator.email(value)) {
                                  return 'Invalid Email';
                                } else {
                                  return null;
                                }
                              },
                              decoration: InputDecoration(
                                hintText: 'Email',
                                border: OutlineInputBorder(
                                    borderSide: BorderSide.none),
                                hintStyle: TextStyle(
                                    fontFamily: 'Circular',
                                    fontSize: pHeight * 0.02),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: pHeight * 0.02,
                        ),
                        Container(
                          width: pWidth * 0.9,
                          decoration: BoxDecoration(
                            color: Color(0xFFE9E9E9),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: TextFormField(
                              controller: nameC,
                              validator: (value) {
                                if (value.length <= 0) {
                                  return 'Enter Name';
                                } else {
                                  return null;
                                }
                              },
                              decoration: InputDecoration(
                                hintText: 'Name',
                                border: OutlineInputBorder(
                                    borderSide: BorderSide.none),
                                hintStyle: TextStyle(
                                    fontFamily: 'Circular',
                                    fontSize: pHeight * 0.02),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: pHeight * 0.01,
                        ),
                        Container(
                          width: pWidth * 0.9,
                          decoration: BoxDecoration(
                            color: Color(0xFFE9E9E9),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: TextFormField(
                              controller: pwC,
                              obscureText: isObscured,
                              validator: (value) {
                                if (value.length < 6) {
                                  return 'Invalid Password';
                                } else {
                                  return null;
                                }
                              },
                              decoration: InputDecoration(
                                suffix: isObscured
                                    ? InkWell(
                                        onTap: () {
                                          setState(() {
                                            isObscured = false;
                                          });
                                        },
                                        child: Icon(
                                          Icons.visibility,
                                          color: Color(0xFF4E4E4E),
                                        ),
                                      )
                                    : InkWell(
                                        onTap: () {
                                          setState(() {
                                            isObscured = true;
                                          });
                                        },
                                        child: Icon(
                                          Icons.visibility_off,
                                          color: Color(0xFF4E4E4E),
                                        ),
                                      ),
                                hintText: 'Password',
                                border: OutlineInputBorder(
                                    borderSide: BorderSide.none),
                                hintStyle: TextStyle(
                                    fontFamily: 'Circular',
                                    fontSize: pHeight * 0.02),
                              ),
                            ),
                          ),
                        ),
                        // SizedBox(
                        //   height: pHeight * 0.01,
                        // ),
                        // InkWell(
                        //   onTap: () {
                        //     Navigator.push(
                        //       context,
                        //       CupertinoPageRoute(
                        //         builder: (context) => LoginPage(),
                        //       ),
                        //     );
                        //   },
                        //   child: Padding(
                        //     padding: const EdgeInsets.only(left: 2.0),
                        //     child: Text(
                        //       'Already have an account?',
                        //       textAlign: TextAlign.start,
                        //       style: TextStyle(
                        //           color: txtColor,
                        //           fontFamily: 'Circular',
                        //           fontSize: pHeight * 0.018),
                        //     ),
                        //   ),
                        // ),
                        SizedBox(
                          height: pHeight * 0.04,
                        ),
                        InkWell(
                          onTap: () async {
                            signIn();
                          },
                          child: Container(
                            width: pWidth * 0.9,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Color(0xFFF04F4E),
                                  Color(0xFFFFB199),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Center(
                                child: Text(
                                  'Sign In',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'Circular',
                                      fontSize: pHeight * 0.03),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void signIn() async {
    String userPass = '';
    String userKey = '';
    DataSnapshot snap =
        await FirebaseDatabase.instance.reference().child('Users').once();
    bool userExists = false;
    print('Checking if user exists');
    if (snap == null || snap.value == null) {
    } else {
      snap.value.forEach((index, data) {
        if (data['email'] == emailC.text) {
          userExists = true;
          userPass = data['pass'];
          userKey = data['key'];
        }
      });
    }
    if (userExists == false) {
      print('Creating New User');
      const _chars =
          'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
      Random _rnd = Random();
      var keyGen = CryptKey();
      var key32 = keyGen.genFortuna(32);
      var stream = LightCrypt(key32, 'ChaCha20');
      String encryptPass =
          stream.encrypt(pwC.text, '${emailC.text}${pwC.text}');
      String getRandomString(int length) =>
          String.fromCharCodes(Iterable.generate(
              length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
      var dbRef = FirebaseDatabase.instance
          .reference()
          .child('Users')
          .child(getRandomString(15));
      dbRef.once().then((DataSnapshot snap) async {
        dbRef.set({
          'email': emailC.text,
          'pass': encryptPass,
          'name': nameC.text,
          'key': key32
        });
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('email', emailC.text);
        await prefs.setString('name', nameC.text);
        print('New User Created with email ${emailC.text}');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => MainScreen(),
          ),
        );
      });
    } else {
      print('Signing User In with email ${emailC.text}');
      var stream = LightCrypt(userKey, 'ChaCha20');
      String decryptPass =
          stream.decrypt(userPass, '${emailC.text}${pwC.text}');
      if (decryptPass == pwC.text) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('email', emailC.text);
        await prefs.setString('name', nameC.text);
        print('Sign In Successful');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => MainScreen(),
          ),
        );
      } else {
        print('Wrong Pass');
      }
    }
  }
}
