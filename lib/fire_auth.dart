import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';

class FireAuth {
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

  static Future<String> passwordlessSigninValidate({
    required String email,
  }) async {
    final PendingDynamicLinkData? data =
        await FirebaseDynamicLinks.instance.getInitialLink();
    final FirebaseAuth auth = FirebaseAuth.instance;

    final Uri deepLink = data!.link;
    print(deepLink.toString());

    String link = deepLink.toString();

    if (auth.isSignInWithEmailLink(link)) {
      try {
        await auth.signInWithEmailLink(
            email: email, emailLink: deepLink.toString());
      } catch (e) {
        print(e);
      }
    }

    return deepLink.toString();
  }

  // static Future<void> sendOTP({
  //   required String phone,
  // }) async {

  // }
}
