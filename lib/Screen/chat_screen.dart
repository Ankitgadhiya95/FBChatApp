import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  ChatScreen(
      {super.key,
      required this.name,
      required this.email,
      required this.docId,
      required this.authEmail});

  final String name;
  final String email;
  final String docId;
  final String authEmail;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController chatController = TextEditingController();
  bool isLoading = false;
  String docId = '';
  String msg = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          isLoading == false
              ? Container()
              : IconButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text('Delete!'),
                            content: Text('Are you sure want to delete?'),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    FirebaseFirestore.instance
                                        .collection('Chat')
                                        .doc(widget.docId)
                                        .collection('chats')
                                        .doc(docId)
                                        .delete();
                                    setState(() {
                                      isLoading = false;
                                    });
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('Yes')),
                              TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('No')),
                            ],
                          );
                        });
                  },
                  icon: Icon(Icons.delete)),
          isLoading == false
              ? Container()
              : IconButton(
                  onPressed: () {
                    chatController.text = msg;
                    setState(() {
                      isLoading = false;
                    });
                    // FirebaseFirestore.instance.collection('Chats').doc(widget.docId)
                  },
                  icon: Icon(Icons.edit))
        ],
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.black,
        title: Text(widget.name, style: TextStyle(color: Colors.white)),
      ),
      body: GestureDetector(
        onTap: () {
          setState(() {
            isLoading = false;
          });
        },
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height - 150,
            child: StreamBuilder(
              stream: getMessages(),
              builder: (context,
                  AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                print(snapshot.data);

                return (snapshot.data == null)
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : (snapshot.data!.docs.isEmpty)
                        ? Text('data')
                        : ListView.builder(
                            reverse: true,
                            shrinkWrap: true,
                            itemCount: snapshot.data!.docs.length,
                            // prototypeItem: ListTile(
                            //   title: Text("first"),
                            // ),
                            itemBuilder: (context, index) {
                              var data = snapshot.data!.docs;
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  child: Align(
                                    alignment:
                                        (data[index]['sendBy'] == widget.email)
                                            ? Alignment.centerLeft
                                            : Alignment.centerRight,
                                    child: InkWell(
                                      onLongPress: () {
                                        setState(() {
                                          isLoading = !isLoading;
                                          docId = data[index].id;
                                          msg = data[index]['message'];
                                        });
                                      },
                                      child: Container(
                                        padding: EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                            color: Colors.green,
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Text(data[index]['message']),
                                            SizedBox(
                                              height: 8,
                                            ),
                                            Text(
                                              data[index]['createdAt']
                                                  .toString()
                                                  .substring(11, 16),
                                              style: TextStyle(fontSize: 10),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
              },
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(8),
        child: TextFormField(
          controller: chatController,
          decoration: InputDecoration(
            suffixIcon: IconButton(
              onPressed: () {
                if (msg == '') {
                  FirebaseFirestore.instance
                      .collection('Chat')
                      .doc(widget.docId)
                      .collection('chats')
                      .doc()
                      .set({
                    'message': chatController.text,
                    'sendBy': widget.authEmail,
                    'createdAt': DateTime.now().toString(),
                  });
                } else {
                  FirebaseFirestore.instance
                      .collection('Chat')
                      .doc(widget.docId)
                      .collection('chats')
                      .doc(docId)
                      .update({
                    'message': chatController.text,
                    // 'createdAt': DateTime.now().toString(),
                  });
                }
                chatController.clear();
              },
              icon: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(50)),
                  child: Icon(
                    Icons.send,
                    color: Colors.white,
                  )),
            ),
          ),
        ),
      ),
    );
  }

  getMessages() {
    print(widget.docId);
    print("widget.docId");
    return FirebaseFirestore.instance
        .collection('Chat')
        .doc(widget.docId)
        .collection('chats')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }
}
