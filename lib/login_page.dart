import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'signup_page.dart';
import 'user_list.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

//Import self built custom firebase class from fire_auth.dart
import 'fire_auth.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);
  @override
  State<LoginPage> createState() => _LoginPage();
}

class _LoginPage extends State<LoginPage> with WidgetsBindingObserver {
  String email = "";
  bool sentOTP = false;
  bool passwordlessSignInResult = false;
  final userNameController = TextEditingController();
  final passwordController = TextEditingController();
  final phoneNumberController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      //For passwordless signin -- when application is resumed, check whether the link has been authenticated
      var result = await FireAuth.passwordlessSigninValidate(email: email);

      // If link has not been previously validated, setState with authentication result
      if (result != null && passwordlessSignInResult == false) {
        setState(() {
          passwordlessSignInResult = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
            height: 715,
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
                        labelText: 'Enter your password',
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 25, vertical: 0),
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      controller: phoneNumberController,
                      decoration: InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText:
                            sentOTP ? 'Enter OTP' : 'Enter your phone number',
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
                                  builder: (context) => UserList()),
                            );

                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text("Login successful"),
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
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 50,
                    width: 320,
                    child: SignInButtonBuilder(
                      text: passwordlessSignInResult
                          ? 'Validated. Tap to Sign-in'
                          : 'Sign in without password',
                      icon: Icons.email,
                      backgroundColor: Colors.blueGrey[700]!,
                      onPressed: () async {
                        if (userNameController.text == "") {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text("Please enter a valid email"),
                          ));
                        } else {
                          if (passwordlessSignInResult == true) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => UserList()),
                            );

                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text("Login successful"),
                            ));

                            passwordlessSignInResult = false;
                          } else {
                            email = userNameController.text;

                            try {
                              FireAuth.passwordlessSignin(email: email);

                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Text(
                                    "Verification E-mail sent successfully"),
                              ));
                            } catch (e) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Text(e.toString()),
                              ));
                            }
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
                      text:
                          sentOTP ? 'Verify OTP' : 'Sign in with phone number',
                      icon: Icons.phone,
                      backgroundColor: Colors.blueGrey[700]!,
                      onPressed: () async {
                        if (phoneNumberController.text == "") {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: sentOTP
                                ? Text("Please enter a valid OTP")
                                : Text("Please enter a valid phone number"),
                          ));
                        } else {
                          try {
                            if (sentOTP == false) {
                              try {
                                await FireAuth.sendOTP(
                                    phone: phoneNumberController.text);
                                sentOTP = true;
                              } catch (e) {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content: Text(e.toString()),
                                ));
                              }
                            } else {
                              try {
                                await FireAuth.verifyOTP(
                                    otp: phoneNumberController.text);

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => UserList()),
                                );

                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content: Text("Login successful"),
                                ));
                              } catch (e) {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content: Text(e.toString()),
                                ));
                              }
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
                            MaterialPageRoute(builder: (context) => UserList()),
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
                            MaterialPageRoute(builder: (context) => UserList()),
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
                                builder: (context) => UserList(),
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
                  const SizedBox(height: 10),
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
