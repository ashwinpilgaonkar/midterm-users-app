import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:midterm_users_app/user_detail.dart';
import 'main.dart';
import 'package:intl/intl.dart';
import 'user_detail.dart';

class UserList extends StatefulWidget {
  UserList();
  @override
  State<UserList> createState() => _UserList();
}

class _UserList extends State<UserList> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  var userData;

  @override
  Widget build(BuildContext context) {
    if (userData == null) {
      firestore.collection("users").get().then((querySnapshot) {
        setState(() => userData = querySnapshot.docs);
      });
    }

    return Scaffold(
      appBar: AppBar(title: Text("Users"), actions: <Widget>[
        Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              onTap: () {
                showLogoutDialog(context);
              },
              child: Icon(
                Icons.logout,
                size: 25,
              ),
            )),
      ]),
      body: Center(
        child: ListView.builder(
          itemCount: userData != null ? userData.length : 0,
          itemBuilder: (context, index) {
            return Card(
                child: InkWell(
              child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: ListTile(
                      leading: Icon(Icons.person, size: 60),
                      title: Text(userData[index].data()['first_name'] +
                          " " +
                          userData[index].data()['last_name']),
                      subtitle: Text("\n" +
                          "Joined on:  " +
                          DateFormat('d MMM y')
                              .format(new DateTime.fromMillisecondsSinceEpoch(
                                  userData[index].data()['tis']))
                              .toString() +
                          " -- " +
                          DateFormat('jm')
                              .format(new DateTime.fromMillisecondsSinceEpoch(
                                  userData[index].data()['tis']))
                              .toString()))),
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UserDetail(userData[index]),
                  )),
            ));
          },
        ),
      ),
    );
  }

  void showLogoutDialog(BuildContext context) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Logout"),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('Are you sure you want to log out?'),
              ],
            ),
          ),
          actions: <Widget>[
            new TextButton(
              child: new Text("NO"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new TextButton(
              child: new Text("YES"),
              onPressed: () async {
                await auth.signOut();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MyApp()),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
