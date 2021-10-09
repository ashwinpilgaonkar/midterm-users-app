import 'package:flutter/material.dart';

class UserDetail extends StatefulWidget {
  var userData;
  UserDetail(this.userData);
  @override
  State<UserDetail> createState() => _UserDetail(userData);
}

class _UserDetail extends State<UserDetail> {
  var userData;
  _UserDetail(this.userData);

  @override
  Widget build(BuildContext context) {
    print("==========");
    print(userData.data());

    return Scaffold(
      appBar: AppBar(
        title: Text("User Details"),
      ),
      body: Center(
        child: Container(
          height: 640,
          width: 370,
          child: SingleChildScrollView(
            child: Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(13),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const SizedBox(height: 20),
                  Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 25, vertical: 16),
                      child: Text(
                        'Name: ' +
                            userData['first_name'] +
                            " " +
                            userData['last_name'],
                        textAlign: TextAlign.left,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      )),
                  Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 25, vertical: 16),
                      child: Text(
                        'Bio: ' + userData['bio'],
                        textAlign: TextAlign.left,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      )),
                  Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 25, vertical: 16),
                      child: Text(
                        'Hometown: ' + userData['hometown'],
                        textAlign: TextAlign.left,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      )),
                  Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 25, vertical: 16),
                      child: Text(
                        'Age: ' + userData['age'],
                        textAlign: TextAlign.left,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      )),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
