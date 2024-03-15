import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase1/Screen/signup_screen.dart';
import 'package:firebase1/Utils/text_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();
  bool isLoding = false;
  bool isGoogleLoding = false;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Future<dynamic> signInWithGoogle() async {
    setState(() {
      isGoogleLoding = true;
    });
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      return await FirebaseAuth.instance
          .signInWithCredential(credential)
          .then((value) async {
        await FirebaseFirestore.instance.collection("users").doc().set({
          'name': value.user!.displayName,
          'email': value.user!.email,
          'password': '123456',
          'uid': value.user!.uid,
          'image': value.user!.photoURL,
          'type':'google'
          // name email.pass,uid
        });
        setState(() {
          isGoogleLoding = false;
        });
        Fluttertoast.showToast(msg: "Login successful");
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => HomeScreen(),
        ));

        SharedPreferences pref = await SharedPreferences.getInstance();
        pref.setBool('isLogin', true);
        print(pref.getBool('isLogin'));
      });
    } on Exception catch (e) {
      // TODO
      print('exception->$e');
      setState(() {
        isGoogleLoding = false;
      });
    }
  }

  Login() async {
    print('ekrj');
    try {
      setState(() {
        isLoding = true;
      });
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: emailController.text, password: passwordController.text)
          .then((value) async {
        setState(() {
          isLoding = false;
        });
        Fluttertoast.showToast(msg: "Login successful");
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => HomeScreen(),
        ));

        SharedPreferences pref = await SharedPreferences.getInstance();
        pref.setBool('isLogin', true);
        print(pref.getBool('isLogin'));
      });
    } catch (e) {
      setState(() {
        isLoding = false;
      });

      if (e.toString().contains("firebase_auth/invalid-email")) {
        Fluttertoast.showToast(msg: "The email address is badly formatted.");
      } else if (e.toString().contains("firebase_auth/invalid-credential")) {
        Fluttertoast.showToast(
            msg:
                "The supplied auth credential is incorrect, malformed or has expired.");
      }
      print(e);
      // TODO
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/chat.jpeg"), fit: BoxFit.fill),
        ),
        alignment: Alignment.center,
        child: Container(
          height: 400,
          width: double.infinity,
          margin: const EdgeInsets.symmetric(horizontal: 30),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white),
            borderRadius: BorderRadius.circular(15),
            color: Colors.black.withOpacity(0.1),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaY: 5, sigmaX: 5),
              child: Padding(
                padding: const EdgeInsets.all(25),
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Spacer(),
                      Center(
                        child: TextUtil(
                          text: "Login",
                          weight: true,
                          size: 30,
                        ),
                      ),
                      const Spacer(),
                      TextUtil(
                        text: "Email",
                      ),
                      Container(
                        height: 35,
                        decoration: const BoxDecoration(
                            border: Border(
                                bottom: BorderSide(color: Colors.white))),
                        child: TextFormField(
                          controller: emailController,
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            suffixIcon: Icon(
                              Icons.mail,
                              color: Colors.white,
                            ),
                            fillColor: Colors.white,
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      const Spacer(),
                      TextUtil(
                        text: "Password",
                      ),
                      Container(
                        height: 35,
                        decoration: const BoxDecoration(
                            border: Border(
                                bottom: BorderSide(color: Colors.white))),
                        child: TextFormField(
                          controller: passwordController,
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            suffixIcon: Icon(
                              Icons.lock,
                              color: Colors.white,
                            ),
                            fillColor: Colors.white,
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      Spacer(),
                      Row(
                        children: [
                          Container(
                            height: 15,
                            width: 15,
                            color: Colors.white,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                              child: TextUtil(
                            text: "Remember Me , FORGET PASSWORD",
                            size: 12,
                            weight: true,
                          ))
                        ],
                      ),
                      const Spacer(),
                      (isLoding == true)
                          ? Container(
                              height: 40,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(30)),
                              alignment: Alignment.center,
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: CircularProgressIndicator(
                                    color: Colors.black, strokeWidth: 1),
                              ))
                          : InkWell(
                              onTap: () {
                                if (formKey.currentState!.validate()) {
                                  Login();
                                }
                                print('object');
                              },
                              child: Container(
                                height: 40,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(30)),
                                alignment: Alignment.center,
                                child: TextUtil(
                                  text: "Log In",
                                  color: Colors.black,
                                ),
                              ),
                            ),
                      const Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextUtil(
                            text: "Don't have a account",
                            size: 12,
                            weight: true,
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => SignUpScreen(),
                              ));
                            },
                            child: Text(
                              "REGISTER",
                              style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      (isGoogleLoding == true)
                          ? Container(
                              height: 40,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(30)),
                              alignment: Alignment.center,
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: CircularProgressIndicator(
                                    color: Colors.black, strokeWidth: 1),
                              ))
                          : InkWell(
                              onTap: () {
                                signInWithGoogle();
                              },
                              child: Container(
                                height: 40,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(30)),
                                alignment: Alignment.center,
                                child: TextUtil(
                                  text: "Log In with Google",
                                  color: Colors.black,
                                ),
                              ),
                            ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
