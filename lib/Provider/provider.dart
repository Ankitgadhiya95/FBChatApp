import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase1/model/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';

class providerClass with ChangeNotifier {
  File? fileImage;
  TextEditingController nameController = TextEditingController();

  User user = FirebaseAuth.instance.currentUser!;

  String? imageUrl;
  String? type;
  bool isLoading = false;
  bool isSwitchTheme = false;
  bool isLodingHomeScreen = false;
  int selectedIndex = 0;

  pickImageFormGallery() async {
    var image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image != null) {
      fileImage = File(image.path);
      notifyListeners();
    }
  }

  pickImageFormCamera() async {
    var image = await ImagePicker().pickImage(source: ImageSource.camera);
    if (image != null) {
      fileImage = File(image.path);
      notifyListeners();
    }
  }

  getData() async {
    // setState(() {
    isLoading = true;
    notifyListeners();
    // });
    var data = await FirebaseFirestore.instance
        .collection('users')
        .where('uid', isEqualTo: user.uid)
        .get();
    nameController.text = data.docs.first.data()['name'];
    // setState(() {
    imageUrl = data.docs.first.data()['image'];
    type = data.docs.first.data()['type'];
    notifyListeners();
    // });
    // setState(() {
    isLoading = false;
    notifyListeners();
    // });
  }

  getupdate() async {
    // final providerVar = Provider.of<providerClass>(context, listen: false);
    String? url;
    // var imageName = DateTime.now().microsecondsSinceEpoch.toString();
    if (fileImage != null) {
      var storageRef = FirebaseStorage.instance
          .ref()
          .child('users_images/${user.email}/${user.uid}.jpg');
      var uploadTask = storageRef.putFile(fileImage!);
      url = await (await uploadTask).ref.getDownloadURL();
    } else {
      url = imageUrl;
    }
    FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .update({'name': nameController.text, 'image': url});
  }

  String chatRoomId(String user1, String user2) {
    if (user1[0].toLowerCase().codeUnits[0] >
        user2.toLowerCase().codeUnits[0]) {
      return "$user1$user2";
    } else {
      return "$user2$user1";
    }
  }

  getUserData() {
    FirebaseFirestore.instance.collection('users').get().then((value) {
      var data = value.docs;
      data.forEach((element) {
        // setState(() {
        userList.add(UserModel.fromJson(element.data()));
        notifyListeners();
        // });
      });
    });
  }

  void onItemTapped(int index) {
    // setState(() {
    selectedIndex = index;
    // });
  }

  set settheme(value) {
    isSwitchTheme = value;
    notifyListeners();
  }

  get gettheme {
    return isSwitchTheme;
  }
}
