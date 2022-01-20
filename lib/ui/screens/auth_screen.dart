import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_session_10/ui/screens/home_screen.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthScreen extends StatefulWidget {

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  TextEditingController emailFormField = TextEditingController();
  TextEditingController passwordFormField = TextEditingController();
  TextEditingController phoneFormField = TextEditingController();

  TextEditingController otpFormField = TextEditingController();

  String verificationID = "";

  bool codeSent = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Container(
        margin: EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (!codeSent)
              TextFormField(
                decoration: InputDecoration(label: Text("Phone number")),
                controller: phoneFormField,
              ),
            if (codeSent)
              TextFormField(
                decoration: InputDecoration(label: Text("OTP")),
                controller: otpFormField,
              ),
            TextFormField(
              controller: emailFormField,
            ),
            TextFormField(
              controller: passwordFormField,
            ),
            ElevatedButton(
                onPressed: () async {
                  User? user;
                  await FirebaseAuth.instance
                      .signInWithEmailAndPassword(
                          email: emailFormField.text,
                          password: passwordFormField.text)
                      .then((value) {
                    user = value.user!;
                  }).catchError((e) => print(e.toString()));
                  if (user!.emailVerified) {
                    print("welcome");
                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=>HomeScreen()));
                  } else {
                    print("wait ");
                    await user!.sendEmailVerification();
                  }
                },
                child: Text("Login")),
            ElevatedButton(
                onPressed: () async {
                  User? user;
                  await FirebaseAuth.instance
                      .createUserWithEmailAndPassword(
                          email: emailFormField.text,
                          password: passwordFormField.text)
                      .then((value) {
                    user = value.user!;
                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=>HomeScreen()));
                  }).catchError((e) => print(e.toString()));
                  await user!.sendEmailVerification();
                },
                child: Text("Create Account")),
            ElevatedButton(
                onPressed: () async {
                  // Trigger the authentication flow
                  final GoogleSignInAccount? googleUser =
                      await GoogleSignIn().signIn();
                  // Obtain the auth details from the request
                  final GoogleSignInAuthentication? googleAuth =
                      await googleUser?.authentication;
                  // Create a new credential
                  final credential = GoogleAuthProvider.credential(
                    accessToken: googleAuth?.accessToken,
                    idToken: googleAuth?.idToken,
                  );
                  User? user;
                  await FirebaseAuth.instance
                      .signInWithCredential(credential)
                      .then((value) {
                    user = value.user!;
                    print(user!.email);
                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=>HomeScreen()));
                  }).catchError((e) => print(e.toString()));
                },
                child: Text("Google")),
            ElevatedButton(
                onPressed: () async {
                  // Trigger the sign-in flow
                  final LoginResult loginResult =
                      await FacebookAuth.instance.login();

                  print(loginResult.status);
                  // Create a credential from the access token
                  final OAuthCredential facebookAuthCredential =
                      FacebookAuthProvider.credential(
                          loginResult.accessToken!.token);
                  User? user;
                  await FirebaseAuth.instance
                      .signInWithCredential(facebookAuthCredential)
                      .then((value) {
                    user = value.user!;
                    print(user!.email);
                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=>HomeScreen()));
                  }).catchError((e) => print(e.toString()));
                },
                child: Text("Facebook")),
            if (!codeSent)
              ElevatedButton(
                  onPressed: () async {
                    await FirebaseAuth.instance.verifyPhoneNumber(
                      phoneNumber: '+2${phoneFormField.text}',
                      verificationCompleted:
                          (PhoneAuthCredential credential) async {
                        //Android only
                        // await FirebaseAuth.instance
                        //     .signInWithCredential(credential)
                        //     .then((value) =>
                        //         print("You are logged in successfully"));
                        print("conplete");
                      },
                      verificationFailed: (FirebaseAuthException e) {
                        print("faild");
                      },
                      codeSent: (String verificationId, int? resendToken) {
                        setState(() {
                          codeSent=true;
                          verificationID = verificationId;
                        });

                        print("code sent");
                      },
                      codeAutoRetrievalTimeout: (String verificationId) {
                        print("timeout");
                      },
                      timeout: Duration(seconds: 60),
                    );
                  },
                  child: Text("Phone number")),
            if (codeSent)
              ElevatedButton(
                  onPressed: () async {
                    PhoneAuthCredential credential =
                        PhoneAuthProvider.credential(
                            verificationId: verificationID,
                            smsCode: otpFormField.text);
                    await FirebaseAuth.instance
                        .signInWithCredential(credential)
                        .then((value) {
                          print("done");
                          Navigator.of(context).push(MaterialPageRoute(builder: (context)=>HomeScreen()));
                    })
                        .catchError((e) {
                      print(e.toString());
                    });
                  },
                  child: Text("verify")),
          ],
        ),
      )),
    );
  }
}
