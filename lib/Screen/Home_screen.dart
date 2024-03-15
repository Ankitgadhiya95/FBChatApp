import 'package:firebase1/Provider/provider.dart';
import 'package:firebase1/Screen/welcome_screen.dart';
import 'package:firebase1/model/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Edit_Screens.dart';
import 'chat_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  @override
  void initState() {
    final providerVar = Provider.of<providerClass>(context, listen: false);
    // TODO: implement initState
    providerVar.getUserData();
    providerVar.getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final providerVar = Provider.of<providerClass>(context, listen: true);
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          "Chat App",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: (providerVar.isLodingHomeScreen == true)
            ? CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 1,
              )
            : Container(
                height: double.infinity,
                color: Colors.white,
                child: ListView.builder(
                  itemCount: userList.length,
                  itemBuilder: (context, index) {
                    return (providerVar.user.uid == userList[index].uid)
                        ? Container()
                        : InkWell(
                            onTap: () {
                              String roomId = providerVar.chatRoomId(
                                  providerVar.user.email!,
                                  userList[index].email!);
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => ChatScreen(
                                  name: userList[index].name!,
                                  email: userList[index].email!,
                                  docId: roomId!,
                                  authEmail: providerVar.user.email!,
                                ),
                              ));
                            },
                            child: Container(
                              height: 100,
                              decoration: BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(color: Colors.red)),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  (userList[index].images != null)
                                      ? CircleAvatar(
                                          radius: 40,
                                          backgroundImage: NetworkImage(
                                              userList[index].images!),
                                        )
                                      : CircleAvatar(
                                          radius: 40,
                                          backgroundColor: Colors.white,
                                          child: Icon(
                                            CupertinoIcons.camera,
                                            color: Colors.black,
                                          ),
                                        ),
                                  Text(
                                    userList[index].name!,
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 18),
                                  ),
                                  Text(
                                    userList[index].email!,
                                    style: TextStyle(
                                        color: Colors.black54, fontSize: 15),
                                  ),
                                ],
                              ),
                            ),
                          );
                  },
                ),
              ),
      ),
      drawer: Drawer(
        child: Column(
          // padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.black,
              ),
              child: Container(
                width: double.infinity,
                child: Column(children: [
                  InkWell(
                      onTap: () {
                        //  showDialogBox();
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ProfileEditScreen(),
                        ));
                      },
                      child: (providerVar.imageUrl != null)
                          ? CircleAvatar(
                              radius: 50,
                              backgroundImage:
                                  NetworkImage(providerVar.imageUrl!),
                            )
                          : CircleAvatar(
                              radius: 50,
                              backgroundColor: Colors.white,
                              child: Icon(
                                CupertinoIcons.camera,
                                color: Colors.black,
                              ),
                            )),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    providerVar.user.email!,
                    style: TextStyle(color: Colors.white, fontSize: 17),
                  )
                ]),
              ),
            ),
            ListTile(
              title: const Text('Theme'),
              trailing: Switch(
                  value: providerVar.gettheme,
                  onChanged: (value) {
                    providerVar.settheme = value;
                  }),
              selected: providerVar.selectedIndex == 0,
              onTap: () {
                providerVar.onItemTapped(0);
                Navigator.pop(context);
              },
            ),
            Spacer(),
            ListTile(
              title: const Text('Logout'),
              leading: Icon(Icons.logout),
              onTap: () {
                Navigator.pop(context);
                showDialog<void>(
                  context: context,
                  barrierDismissible: false, // user must tap button!
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Logout!!!'),
                      content: const SingleChildScrollView(
                        child: ListBody(
                          children: <Widget>[
                            const Text('Are you sure you want to Logout?'),
                          ],
                        ),
                      ),
                      actions: <Widget>[
                        TextButton(
                          child: const Text('Yes'),
                          onPressed: () async {
                            SharedPreferences pref =
                                await SharedPreferences.getInstance();
                            pref.clear();
                            await FirebaseAuth.instance.signOut();
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: (context) => WelcomeScreen()),
                                (route) => false);
                          },
                        ),
                        TextButton(
                          child: const Text('No'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
