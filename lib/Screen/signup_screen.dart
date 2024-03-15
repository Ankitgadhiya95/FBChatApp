import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase1/Utils/text_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'login_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmpasswordController = TextEditingController();
  bool isLoding = false;

  Signup() async {
    try {
      setState(() {
        isLoding = true;
      });
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: emailController.text, password: passwordController.text)
          .then((value) async {
        await FirebaseFirestore.instance.collection("users").doc().set({
          'name': nameController.text,
          'email': emailController.text,
          'password': passwordController.text,
          'uid': value.user!.uid,
          'image': '',
          'type':'email'
          // name email.pass,uid
        });
        setState(() {
          isLoding = false;
        });
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => LoginScreen(),
        ));
      });
    } catch (e) {
      setState(() {
        isLoding = false;
      });
      if (e.toString().contains("firebase_auth/email-already-in-use")) {
        Fluttertoast.showToast(
            msg: "The email address is already in use by another account.");
      } else if (e.toString().contains("firebase_auth/weak-password")) {
        Fluttertoast.showToast(msg: "Password should be at least 6 characters");
      } else if (e.toString().contains("firebase_auth/invalid-email")) {
        Fluttertoast.showToast(msg: "The email address is badly formatted.");
      } else if (e.toString().contains("firebase_auth/weak-password")) {
        Fluttertoast.showToast(msg: "Password should be at least 6 characters");
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
        child: SingleChildScrollView(
          child: Container(
            height: 550,
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 30),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white),
              borderRadius: BorderRadius.circular(15),
              color: Colors.black.withOpacity(0.1),
            ),
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
                        text: "Register",
                        weight: true,
                        size: 30,
                      ),
                    ),
                    const Spacer(),
                    TextUtil(
                      text: "Enter Name",
                    ),
                    TextFormField(
                      controller: nameController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Enter Name";
                        }
                      },
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        suffixIcon: Icon(
                          Icons.person,
                          color: Colors.white,
                        ),
                        fillColor: Colors.white,
                        //border: InputBorder.none,
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    TextUtil(
                      text: "Email",
                    ),
                    TextFormField(
                      controller: emailController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Enter Email";
                        }
                      },
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        suffixIcon: Icon(
                          Icons.mail,
                          color: Colors.white,
                        ),
                        fillColor: Colors.white,
                        //border: InputBorder.none,
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    TextUtil(
                      text: "Password",
                    ),
                    TextFormField(
                      controller: passwordController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Enter Password";
                        }
                      },
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        suffixIcon: Icon(
                          Icons.lock,
                          color: Colors.white,
                        ),
                        fillColor: Colors.white,
                        // border: InputBorder.none,
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    TextUtil(
                      text: "Confirm Password",
                    ),
                    TextFormField(
                      controller: confirmpasswordController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Enter Confirm Password";
                        }
                      },
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        suffixIcon: Icon(
                          Icons.lock,
                          color: Colors.white,
                        ),
                        fillColor: Colors.white,
                        // border: InputBorder.none,
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    (isLoding == true)
                        ? Container(
                            height: 40,
                            width: double.infinity,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(30)),
                            alignment: Alignment.center,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CircularProgressIndicator(
                                color: Colors.black,
                                strokeWidth: 1,
                              ),
                            ))
                        : InkWell(
                            onTap: () {
                              if (formKey.currentState!.validate()) {
                                print("Submit");
                                Signup();
                              }
                            },
                            child: Container(
                              height: 40,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(30)),
                              alignment: Alignment.center,
                              child: TextUtil(
                                text: "Register",
                                color: Colors.black,
                              ),
                            ),
                          ),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      //crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        TextUtil(
                          text: "I have an account?",
                          size: 14,
                          weight: true,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => LoginScreen(),
                            ));
                          },
                          child: Text(
                            "Login",
                            style: TextStyle(
                                color: Colors.red, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
