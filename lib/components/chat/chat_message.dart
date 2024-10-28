import 'package:flutter/material.dart';

import 'package:hedieaty_mobile_app/static/__init__.dart';

class ChatMessage extends StatelessWidget {
    const ChatMessage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 14.0,
                vertical: 12.0,
              ),
              decoration: BoxDecoration(
                color: AppColors.greyBackground,
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: const Text(
                "Event",
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 16.0,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
