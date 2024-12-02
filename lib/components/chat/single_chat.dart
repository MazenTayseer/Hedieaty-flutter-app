import 'package:flutter/material.dart';

import 'package:hedieaty_mobile_app/pages/chat_screen.dart';
import 'package:hedieaty_mobile_app/static/colors.dart';

class SingleChat extends StatelessWidget {
  final String userId;
  final String contactName;
  final String lastEvent;
  final int unreadMessages;
  final NetworkImage chatImage;

  const SingleChat({
    super.key,
    required this.userId,
    required this.contactName,
    required this.lastEvent,
    required this.unreadMessages,
    required this.chatImage,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, '/chat-screen',
            arguments: ChatScreen(
              userId: userId,
              contactName: contactName,
              chatImage: chatImage,
            ));
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 28.0,
            backgroundImage: chatImage,
          ),
          const SizedBox(width: 20.0),
          Expanded(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          contactName,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0,
                            color: AppColors.white,
                          ),
                        ),
                        Text(
                          lastEvent,
                          style: const TextStyle(
                            color: AppColors.greyText,
                          ),
                        ),
                      ],
                    ),
                    unreadMessages > 0
                        ? Container(
                            padding: const EdgeInsets.all(8),
                            decoration: const BoxDecoration(
                              color: AppColors.green,
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              '$unreadMessages',
                              style: const TextStyle(
                                color: AppColors.background,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          )
                        : const SizedBox.shrink(),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
