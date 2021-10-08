import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'signup_page.dart';
import 'messages_view.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'fire_auth.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);
  @override
  State<LoginPage> createState() => _LoginPage();
}

class _LoginPage extends State<LoginPage> {
  String email = "";

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print("HERE==================");
    if (state == AppLifecycleState.resumed) {
      FireAuth.passwordlessSigninValidate(email: email);
    }
  }

  @override
  Widget build(BuildContext context) {
    FirebaseAuth auth = FirebaseAuth.instance;

    final userNameController = TextEditingController();
    final passwordController = TextEditingController();

    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/background.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: Center(
        child: SingleChildScrollView(
            child: new Column(children: [
          const SizedBox(height: 15),
          Container(
            height: 650,
            width: 370,
            child: Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  // const SizedBox(height: 60),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 25, vertical: 0),
                    child: TextFormField(
                      controller: userNameController,
                      decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        // errorText: 'Error',
                        labelText: 'Enter your email',
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 25, vertical: 16),
                    child: TextFormField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        // errorText: 'Error',
                        labelText: 'Enter your password',
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 50,
                    width: 320,
                    child: SignInButtonBuilder(
                      text: 'Sign in with Email',
                      icon: Icons.email,
                      backgroundColor: Colors.blueGrey[700]!,
                      onPressed: () async {
                        if (userNameController.text == "") {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text("Please enter a valid email"),
                          ));
                        } else if (passwordController.text == "") {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text("Please enter a valid password"),
                          ));
                        } else {
                          try {
                            await FireAuth.emailPasswordSignin(
                                email: userNameController.text,
                                password: passwordController.text);

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MessagesView("")),
                            );

                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text("Login successful"),
                            ));
                          } on FirebaseAuthException catch (e) {
                            if (e.code == 'user-not-found') {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Text("No user found with that email"),
                              ));
                            } else if (e.code == 'wrong-password') {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Text("Incorrect password"),
                              ));
                            }
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(e.toString()),
                            ));
                          }
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 50,
                    width: 320,
                    child: SignInButtonBuilder(
                      text: 'Sign in without password',
                      icon: Icons.email,
                      backgroundColor: Colors.blueGrey[700]!,
                      onPressed: () async {
                        if (userNameController.text == "") {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text("Please enter a valid email"),
                          ));
                        } else {
                          email = userNameController.text;

                          try {
                            FireAuth.passwordlessSignin(email: email);

                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content:
                                  Text("Verification E-mail sent successfully"),
                            ));
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(e.toString()),
                            ));
                          }
                        }
                      },
                    ),
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                    height: 50,
                    width: 320,
                    child: SignInButtonBuilder(
                      text: 'Sign in with phone number',
                      icon: Icons.phone,
                      backgroundColor: Colors.blueGrey[700]!,
                      onPressed: () async {
                        if (userNameController.text == "") {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text("Please enter a valid email"),
                          ));
                        } else if (passwordController.text == "") {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text("Please enter a valid password"),
                          ));
                        } else {
                          try {
                            await auth.signInWithEmailAndPassword(
                                email: userNameController.text,
                                password: passwordController.text);

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MessagesView("")),
                            );

                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text("Login successful"),
                            ));
                          } on FirebaseAuthException catch (e) {
                            if (e.code == 'user-not-found') {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Text("No user found with that email"),
                              ));
                            } else if (e.code == 'wrong-password') {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Text("Incorrect password"),
                              ));
                            }
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(e.toString()),
                            ));
                          }
                        }
                      },
                    ),
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                    height: 50,
                    width: 320,
                    child: SignInButtonBuilder(
                      text: 'Sign in anonymously',
                      icon: Icons.person,
                      backgroundColor: Colors.blueGrey[700]!,
                      onPressed: () async {
                        try {
                          await FireAuth.anonymousSignin();

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MessagesView("")),
                          );

                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text("Login successful"),
                          ));
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(e.toString()),
                          ));
                        }
                      },
                    ),
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                    height: 50,
                    width: 320,
                    child: SignInButton(
                      Buttons.GoogleDark,
                      onPressed: () async {
                        try {
                          await FireAuth.googleSignin();

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MessagesView("")),
                          );

                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text("Login successful"),
                          ));
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(e.toString()),
                          ));
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 50,
                    width: 320,
                    child: SignInButton(
                      Buttons.FacebookNew,
                      onPressed: () async {
                        try {
                          await FireAuth.facebookSignin();

                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MessagesView(""),
                              ));

                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text("Login successful"),
                          ));
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(e.toString()),
                          ));
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 25),
                  RichText(
                    text: TextSpan(
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                      children: <TextSpan>[
                        TextSpan(text: 'Don\'t have an account? '),
                        TextSpan(
                            text: 'Sign Up',
                            style: TextStyle(color: Colors.blue),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SignUpPage()),
                                );
                              }),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 15),
        ])),
      ),
    );
  }
}
