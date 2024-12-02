import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hedieaty_mobile_app/static/colors.dart';
import 'package:intl/intl.dart';

class ChatMessage extends StatelessWidget {
  final String eventId;
  final String eventName;
  final String eventLocation;
  final Timestamp eventDate;
  final String eventDescription;

  const ChatMessage({
    super.key,
    required this.eventId,
    required this.eventName,
    required this.eventLocation,
    required this.eventDate,
    required this.eventDescription,
  });

  @override
  Widget build(BuildContext context) {
    final DateTime dateTime = eventDate.toDate();
    final String formattedDate = DateFormat('MMMM dd, yyyy').format(dateTime);
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        color: AppColors.greyBackground,
        child: ListTile(
          onTap: () {
            Navigator.pushNamed(
              context,
              '/event-details',
              arguments: {
                'eventId': eventId,
                'eventName': eventName,
                'eventLocation': eventLocation,
                'eventDate': eventDate,
                'eventDescription': eventDescription,
              },
            );
          },
          contentPadding: const EdgeInsets.all(16.0),
          title: Text(
            eventName,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18.0,
              color: AppColors.white,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8.0),
              Text(
                "Location: $eventLocation",
                style: const TextStyle(
                  fontSize: 14.0,
                  color: AppColors.greyText,
                ),
              ),
              const SizedBox(height: 4.0),
              Text(
                "Date: $formattedDate",
                style: const TextStyle(
                  fontSize: 14.0,
                  color: AppColors.greyText,
                ),
              ),
              const SizedBox(height: 4.0),
              Text(
                "Description: $eventDescription",
                style: const TextStyle(
                  fontSize: 14.0,
                  color: AppColors.greyText,
                ),
              ),
            ],
          ),
          trailing: const Icon(
            Icons.event,
            color: AppColors.blue,
          ),
        ),
      ),
    );
  }
}
