import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SingaleChatScreen extends StatefulWidget {
  SingaleChatScreen({
    super.key,
    required this.sendby,
    required this.message,
    required this.createdAt,
    required this.useremail,
  });

  final String useremail;
  final String message;
  final String createdAt;
  final String sendby;

  @override
  State<SingaleChatScreen> createState() => _SingaleChatScreenState();
}

class _SingaleChatScreenState extends State<SingaleChatScreen> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        //   width: 50,
        //   height: 40,
        // color: Colors.red,
        child: Align(
          alignment: (widget.sendby == widget.useremail)
              ? Alignment.centerLeft
              : Alignment.centerRight,
          child: CupertinoContextMenu(
            actions: <Widget>[
              CupertinoContextMenuAction(
                onPressed: () {
                  //Navigator.pop(context);
                },
                isDefaultAction: true,
                trailingIcon: CupertinoIcons.doc_on_clipboard_fill,
                child: const Text('Copy'),
              ),
              CupertinoContextMenuAction(
                onPressed: () {
                  Navigator.pop(context);
                },
                trailingIcon: CupertinoIcons.share,
                child: const Text('Share'),
              ),
              CupertinoContextMenuAction(
                onPressed: () {
                  Navigator.pop(context);
                },
                trailingIcon: CupertinoIcons.heart,
                child: const Text('Favorite'),
              ),
              CupertinoContextMenuAction(
                onPressed: () {
                  Navigator.pop(context);
                },
                isDestructiveAction: true,
                trailingIcon: CupertinoIcons.delete,
                child: const Text('Delete'),
              ),
            ],
            child: Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: Colors.green, borderRadius: BorderRadius.circular(20)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(widget.message),
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    widget.createdAt.toString().substring(11, 16),
                    style: TextStyle(fontSize: 10),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
