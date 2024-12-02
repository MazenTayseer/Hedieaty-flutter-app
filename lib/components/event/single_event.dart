import 'package:flutter/material.dart';
import 'package:hedieaty_mobile_app/components/reusable/custom_divider.dart';
import 'package:hedieaty_mobile_app/pages/my_event_gifts.dart';
import 'package:hedieaty_mobile_app/static/colors.dart';

import 'package:hedieaty_mobile_app/database_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hedieaty_mobile_app/components/reusable/show_snack_bar.dart';
import 'package:intl/intl.dart';

class SingleEvent extends StatelessWidget {
  final String eventId;
  final String eventName;
  final String eventLocation;
  final Timestamp eventDate;
  final String cloudType;
  final VoidCallback onDelete;

  const SingleEvent({
    super.key,
    required this.eventId,
    required this.eventName,
    required this.eventLocation,
    required this.eventDate,
    required this.cloudType,
    required this.onDelete,
  });

  Future<void> _deleteFromCloud(String id, BuildContext context) async {
    try {
      await FirebaseFirestore.instance.collection('Events').doc(id).delete();
      showSnackBarSuccess(context, 'Event deleted from cloud successfully!');
      onDelete();
    } catch (e) {
      showSnackBarError(context, 'Failed to delete from cloud: $e');
    }
  }

  Future<void> _deleteFromLocal(String id, BuildContext context) async {
    final db = DatabaseHelper.instance;
    try {
      await db.delete('Events', where: 'id = ?', whereArgs: [id]);
      showSnackBarSuccess(context, 'Event deleted from local database!');
      onDelete();
    } catch (e) {
      showSnackBarError(context, 'Failed to delete from local: $e');
    }
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirm Deletion'),
        content: Text(
            'Are you sure you want to delete this $cloudType event? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              if (cloudType == 'local') {
                _deleteFromLocal(eventId, context);
              } else {
                _deleteFromCloud(eventId, context);
              }
            },
            child: const Text(
              'Delete',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final DateTime dateTime = eventDate.toDate();
    final String formattedDate = DateFormat('MMMM dd, yyyy').format(dateTime);

    return Column(
      children: [
        InkWell(
          onTap: () {
            if (cloudType == 'cloud') {
              Navigator.pushNamed(context, '/my-event-gifts',
                  arguments:
                      MyEventGifts(eventId: eventId, eventName: eventName));
            } else {
              showSnackBarError(context, 'Upload to Cloud to view gifts!');
            }
          },
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                              eventName,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0,
                                color: AppColors.white,
                              ),
                            ),
                            Text(
                              eventLocation,
                              style: const TextStyle(
                                color: AppColors.greyText,
                              ),
                            ),
                            Text(
                              formattedDate,
                              style: const TextStyle(
                                color: AppColors.greyText,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                // Placeholder for edit functionality
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.blue,
                                  foregroundColor: AppColors.white,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 6.0, vertical: 3.0),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.0),
                                  )),
                              child: const Icon(Icons.edit, size: 16.0),
                            ),
                            const SizedBox(height: 8),
                            ElevatedButton(
                              onPressed: () => _confirmDelete(context),
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.red,
                                  foregroundColor: AppColors.white,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 6.0, vertical: 3.0),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.0),
                                  )),
                              child: const Icon(Icons.delete, size: 16.0),
                            ),
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const CustomDivider(),
      ],
    );
  }
}
