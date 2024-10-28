import 'package:flutter/material.dart';

import 'package:hedieaty_mobile_app/components/__init__.dart';

class ChatScreen extends StatelessWidget {
  final String contactName;
  final NetworkImage chatImage;

  const ChatScreen({
    super.key,
    required this.contactName,
    required this.chatImage,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              const SizedBox(width: 15),
              CircleAvatar(
                radius: 20.0,
                backgroundImage: chatImage,
              ),
              const SizedBox(width: 10.0),
              Text(
                contactName,
                style: const TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: [
            ChatMessage(),
            ChatMessage(),
          ],
        ),
      ),
    );
  }
}
