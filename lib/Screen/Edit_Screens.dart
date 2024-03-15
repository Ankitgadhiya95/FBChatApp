import 'package:firebase1/Provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

User user = FirebaseAuth.instance.currentUser!;

class ProfileEditScreen extends StatefulWidget {
  const ProfileEditScreen({super.key});

  @override
  State<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  showDialogBox() {
    return showDialog(
        context: context,
        builder: (context) {
          return Consumer<providerClass>(builder: (context, conVar, child) {
            return AlertDialog(
              title: Text('Select From'),
              content: Container(
                height: 80,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        conVar.pickImageFormCamera();
                        Navigator.of(context).pop();
                      },
                      child: Column(
                        children: [
                          Icon(
                            CupertinoIcons.camera,
                            color: Colors.black,
                            size: 40,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text('Camera',
                              style:
                                  TextStyle(color: Colors.black, fontSize: 20)),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    InkWell(
                      onTap: () {
                        conVar.pickImageFormGallery();
                        Navigator.of(context).pop();
                      },
                      child: Column(
                        children: [
                          Icon(
                            Icons.image,
                            color: Colors.black,
                            size: 40,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            'Galllery',
                            style: TextStyle(color: Colors.black, fontSize: 20),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          });
        });
  }

  @override
  void initState() {
    final providerVar = Provider.of<providerClass>(context, listen: false);
    // TODO: implement initState
    providerVar.getData();
    // nameController.text = user.displayName!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final providerVar = Provider.of<providerClass>(context, listen: true);
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.black,
        title: Text(
          "Edit Profile",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: (providerVar.isLoading == true)
          ? Center(
              child: CircularProgressIndicator(
                color: Colors.black,
              ),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                  InkWell(
                    onTap: () {
                      showDialogBox();
                    },
                    child: (providerVar.fileImage != null)
                        ? CircleAvatar(
                            radius: 65,
                            backgroundImage: FileImage(providerVar.fileImage!),
                          )
                        : (providerVar.imageUrl != "")
                            ? CircleAvatar(
                                radius: 65,
                                backgroundImage:
                                    NetworkImage(providerVar.imageUrl!))
                            : CircleAvatar(
                                radius: 65,
                                backgroundColor: Colors.black,
                                child: Icon(
                                  CupertinoIcons.camera,
                                  color: Colors.white,
                                ),
                              ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: providerVar.nameController,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 25, color: Colors.black),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    providerVar.user.email!,
                    style: TextStyle(color: Colors.black, fontSize: 20),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  ElevatedButton(
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.black),
                    onPressed: () {
                      providerVar.getupdate();
                    },
                    child: Text(
                      "Save",
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                ]),
    );
  }
}
