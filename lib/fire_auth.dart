import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';

class FireAuth {
  static var smsVerificationId;

  static Future<User?> emailPasswordSignin({
    required String email,
    required String password,
  }) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: email, password: password);

      user = userCredential.user;
      // await user!.updateProfile(displayName: name);
      // await user.reload();
    } on FirebaseAuthException catch (e) {
      throw e;
    } catch (e) {
      throw e;
    }
    return user;
  }

  static Future<User?> anonymousSignin() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;
    try {
      UserCredential userCredential = await auth.signInAnonymously();

      user = userCredential.user;
    } on FirebaseAuthException catch (e) {
      throw e;
    } catch (e) {
      throw e;
    }
    return user;
  }

  static Future<UserCredential?> googleSignin() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    UserCredential? result;
    FirebaseAuth auth = FirebaseAuth.instance;
    if (googleUser != null) {
      try {
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;

        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        result = await auth.signInWithCredential(credential);
      } catch (e) {
        throw e;
      }

      return result;
    }
  }

  static Future<UserCredential?> facebookSignin() async {
    try {
      final LoginResult loginResult = await FacebookAuth.instance.login();

      final OAuthCredential facebookAuthCredential =
          FacebookAuthProvider.credential(loginResult.accessToken!.token);

      return FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
    } catch (e) {
      print(e);
      throw e;
    }
  }

  static void passwordlessSignin({
    required String email,
  }) async {
    FirebaseAuth auth = FirebaseAuth.instance;

    var acs = ActionCodeSettings(
        url: 'https://ashwinusers.page.link/',
        handleCodeInApp: true,
        // iOSBundleId: 'com.example.ios',
        androidPackageName: 'com.example.midterm_users_app',
        androidInstallApp: true,
        androidMinimumVersion: '12');

    try {
      await auth.sendSignInLinkToEmail(email: email, actionCodeSettings: acs);
    } catch (e) {
      throw e;
    }
  }

  static Future<UserCredential?> passwordlessSigninValidate({
    required String email,
  }) async {
    var result;

    final PendingDynamicLinkData? data =
        await FirebaseDynamicLinks.instance.getInitialLink();
    final FirebaseAuth auth = FirebaseAuth.instance;

    if (data != null) {
      final Uri deepLink = data.link;
      print(deepLink.toString());

      String link = deepLink.toString();

      if (auth.isSignInWithEmailLink(link)) {
        try {
          result = await auth.signInWithEmailLink(
              email: email, emailLink: deepLink.toString());
        } catch (e) {
          print(e);
        }
      }
    }

    return result;
  }

  static Future<void> sendOTP({
    required String phone,
  }) async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    return await auth.verifyPhoneNumber(
      phoneNumber: phone,
      verificationCompleted: _onVerificationCompleted,
      verificationFailed: _onVerificationFailed,
      codeSent: _onCodeSent,
      codeAutoRetrievalTimeout: _onCodeTimeout,
    );
  }

  static Future<UserCredential> verifyOTP({
    required String otp,
  }) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    // Create a PhoneAuthCredential with the code
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: smsVerificationId, smsCode: otp);

    // Sign the user in (or link) with the credential
    var result = await auth.signInWithCredential(credential);
    return result;
  }

  //Unused auto OTP validation callback
  static _onVerificationCompleted(PhoneAuthCredential authCredential) async {
    print("=========ON VERIFICATION COMPLETE===========");
  }

  //Phone verification failed callback
  static _onVerificationFailed(FirebaseAuthException exception) {
    print("======ON VERIFICATION FAILED===========");
    throw exception;
  }

  //Phone OTP sent callback
  static _onCodeSent(String verificationId, int? forceResendingToken) {
    print("======ON CODE SENT===========");
    smsVerificationId = verificationId;
  }

  //Timed out callback
  static _onCodeTimeout(String timeout) {
    print("======ON CODE TIMEOUT===========");
    return null;
  }
}
