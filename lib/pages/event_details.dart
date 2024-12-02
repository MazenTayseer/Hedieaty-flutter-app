import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hedieaty_mobile_app/static/colors.dart';
import 'package:intl/intl.dart';

class EventDetailsPage extends StatefulWidget {
  final String eventId;
  final String eventName;
  final String eventLocation;
  final Timestamp eventDate;
  final String eventDescription;

  const EventDetailsPage({
    super.key,
    required this.eventId,
    required this.eventName,
    required this.eventLocation,
    required this.eventDate,
    required this.eventDescription,
  });

  @override
  State<EventDetailsPage> createState() => _EventDetailsPageState();
}

class _EventDetailsPageState extends State<EventDetailsPage> {
  late DateTime dateTime;
  late String formattedDate;

  @override
  void initState() {
    super.initState();
    dateTime = widget.eventDate.toDate();
    formattedDate = DateFormat('MMMM dd, yyyy').format(dateTime);
  }

  Future<List<Map<String, dynamic>>> _fetchGifts() async {
    final giftsSnapshot = await FirebaseFirestore.instance
        .collection('Gifts')
        .where('event_id', isEqualTo: widget.eventId)
        .get();

    return giftsSnapshot.docs.map((doc) {
      final data = doc.data();
      return {
        'id': doc.id,
        'name': data['name'],
        'status': data['status'],
        'price': data['price'],
        'description': data['description'],
      };
    }).toList();
  }

  Future<void> _updateGiftStatus(String giftId, String newStatus) async {
    try {
      await FirebaseFirestore.instance
          .collection('Gifts')
          .doc(giftId)
          .update({'status': newStatus});
      setState(() {}); // Refresh the UI
    } catch (e) {
      throw Exception('Failed to update gift status: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('${widget.eventName} Details'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Event Details'),
              Tab(text: 'Gifts'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Event Details',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24.0,
                      color: AppColors.white,
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Text(
                    'Name: ${widget.eventName}',
                    style:
                        const TextStyle(fontSize: 18.0, color: AppColors.white),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    'Location: ${widget.eventLocation}',
                    style:
                        const TextStyle(fontSize: 18.0, color: AppColors.white),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    'Date: ${widget.eventDate}',
                    style:
                        const TextStyle(fontSize: 18.0, color: AppColors.white),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    'Description: ${widget.eventDescription}',
                    style:
                        const TextStyle(fontSize: 18.0, color: AppColors.white),
                  ),
                ],
              ),
            ),
            FutureBuilder<List<Map<String, dynamic>>>(
              future: _fetchGifts(),
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

                final gifts = snapshot.data ?? [];

                if (gifts.isEmpty) {
                  return const Center(
                    child: Text(
                      'No gifts found for this event.',
                      style: TextStyle(fontSize: 16.0, color: AppColors.white),
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: gifts.length,
                  itemBuilder: (context, index) {
                    final gift = gifts[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(12.0),
                        leading: CircleAvatar(
                          backgroundColor: gift['status'] == 'pledged'
                              ? AppColors.green
                              : gift['status'] == 'purchased'
                                  ? Colors.blue
                                  : AppColors.red,
                          child: Text(
                            gift['name'][0].toUpperCase(),
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        title: Text(
                          gift['name'],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0,
                            color: AppColors.white,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Description: ${gift['description']}',
                                style: const TextStyle(color: AppColors.white)),
                            Text('Price: \$${gift['price']}',
                                style: const TextStyle(color: AppColors.white)),
                            Text('Status: ${gift['status']}',
                                style: const TextStyle(color: AppColors.white)),
                          ],
                        ),
                        trailing: PopupMenuButton<String>(
                          onSelected: (value) async {
                            try {
                              await _updateGiftStatus(gift['id'], value);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content:
                                      Text('Gift status updated to $value'),
                                  backgroundColor: Colors.green,
                                ),
                              );
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Failed to update status: $e'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          },
                          itemBuilder: (context) {
                            return ['available', 'pledged', 'purchased']
                                .map(
                                  (status) => PopupMenuItem(
                                    value: status,
                                    child: Text(status),
                                  ),
                                )
                                .toList();
                          },
                        ),
                      ),
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
