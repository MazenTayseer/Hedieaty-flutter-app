import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hedieaty_mobile_app/components/chat/chat_message.dart';
import 'package:hedieaty_mobile_app/static/colors.dart';

class ChatScreen extends StatelessWidget {
  final String userId;
  final String contactName;
  final NetworkImage chatImage;

  const ChatScreen({
    super.key,
    required this.userId,
    required this.contactName,
    required this.chatImage,
  });

  Future<List<Map<String, dynamic>>> _getUserEvents() async {
    try {
      final eventsSnapshot = await FirebaseFirestore.instance
          .collection('Events')
          .where('user_id', isEqualTo: userId)
          .orderBy('date', descending: true)
          .get();

      return eventsSnapshot.docs.map((doc) {
        final data = doc.data();
        return {
          'id': doc.id,
          'name': data['name'],
          'location': data['location'],
          'description': data['description'],
          'date': data['date'],
        };
      }).toList();
    } catch (e) {
      throw Exception('Failed to load events: $e');
    }
  }

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
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _getUserEvents(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          final events = snapshot.data ?? [];

          if (events.isEmpty) {
            return const Center(
              child: Text(
                'No events found.',
                style: TextStyle(
                  color: AppColors.greyText,
                  fontSize: 18,
                ),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(20.0),
            itemCount: events.length,
            itemBuilder: (context, index) {
              final event = events[index];
              return ChatMessage(
                eventId: event['id'],
                eventName: event['name'],
                eventLocation: event['location'],
                eventDate: event['date'],
                eventDescription: event['description'],
              );
            },
          );
        },
      ),
    );
  }
}
