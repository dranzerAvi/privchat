import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:privchat/Classes/Constants.dart';
import 'package:privchat/Screens/ChatScreen.dart';
import 'package:privchat/Screens/SignInScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  String userName;
  getName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userName = await prefs.getString('name');
  }

  @override
  void initState() {
    getName();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkColor,
      appBar: new AppBar(
        backgroundColor: kPrimaryColor,
        title: new Text("Privchat"),
        actions: [
          InkWell(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                Icons.logout,
                color: Colors.white,
              ),
            ),
            onTap: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              await prefs.remove('email');
              await prefs.remove('name');
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => SignIn(),
                ),
              );
            },
          )
        ],
      ),
      body: SafeArea(
        child: Container(
          child: StreamBuilder(
            stream:
                FirebaseDatabase.instance.reference().child('Users').onValue,
            builder: (context, snap) {
              if (snap.hasData &&
                  !snap.hasError &&
                  snap.data.snapshot.value != null) {
                Map data = snap.data.snapshot.value;
                List item = [];

                data.forEach(
                    (index, data) => item.add({"key": index, ...data}));
                return Expanded(
                  child: ListView.builder(
                    itemCount: item.length,
                    itemBuilder: (context, index) {
                      if (item[index]['name'] != userName)
                        return ListTile(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ChatScreen(item[index]['name']),
                              ),
                            );
                          },
                          leading: CircleAvatar(
                            child: Image.network(
                                'https://static.thenounproject.com/png/4291178-200.png'),
                            backgroundImage: NetworkImage(
                                'https://static.thenounproject.com/png/4291178-200.png'),
                            backgroundColor: Colors.white,
                          ),
                          title: Text(item[index]['name']),
                        );
                      else
                        return Container();
                    },
                  ),
                );
              } else {
                return Center(child: Text("No data"));
              }
            },
          ),
        ),
      ),
    );
  }
}
