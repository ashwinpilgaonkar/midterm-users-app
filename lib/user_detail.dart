import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';

class UserDetail extends StatefulWidget {
  var userData;
  UserDetail(this.userData);
  @override
  State<UserDetail> createState() => _UserDetail(userData);
}

class _UserDetail extends State<UserDetail> {
  var userData;
  var url;
  _UserDetail(this.userData);

  @override
  void initState() {
    super.initState();

    fetchDpfromFirebase();
  }

  void fetchDpfromFirebase() async {
    final ref = FirebaseStorage.instance
        .ref()
        .child('profile-pictures')
        .child('/' + userData.data()['uid']);

    final imgUrl = await ref.getDownloadURL();
    setState(() {
      url = imgUrl;
    });
  }

  @override
  Widget build(BuildContext context) {
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
                  const SizedBox(height: 30),
                  url != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(500),
                          child: Image.network(url,
                              height: 150, width: 150, fit: BoxFit.fill))
                      : Container(),
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
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      )),
                  Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 25, vertical: 16),
                      child: Text(
                        'Bio: ' + userData['bio'],
                        textAlign: TextAlign.left,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      )),
                  Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 25, vertical: 16),
                      child: Text(
                        'Hometown: ' + userData['hometown'],
                        textAlign: TextAlign.left,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      )),
                  Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 25, vertical: 16),
                      child: Text(
                        'Age: ' + userData['age'],
                        textAlign: TextAlign.left,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
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
