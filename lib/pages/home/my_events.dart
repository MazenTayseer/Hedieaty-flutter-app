import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hedieaty_mobile_app/auth.dart';
import 'package:hedieaty_mobile_app/components/event/single_event.dart';
import 'package:hedieaty_mobile_app/components/reusable/bottom_bar.dart';

import 'package:hedieaty_mobile_app/components/reusable/show_snack_bar.dart';
import 'package:hedieaty_mobile_app/static/colors.dart';

import 'package:hedieaty_mobile_app/database_helper.dart';

class MyEvents extends StatefulWidget {
  const MyEvents({super.key});

  @override
  State<MyEvents> createState() => _MyEventsState();
}

class _MyEventsState extends State<MyEvents> {
  late Future<Map<String, List<Map<String, dynamic>>>> eventsFuture;
  final db = DatabaseHelper.instance;
  bool isUploading = false;
  String? currentUserId;

  @override
  void initState() {
    super.initState();
    _loadCurrentUser();
    _reloadEvents();
  }

  Future<void> _loadCurrentUser() async {
    try {
      final userDoc = await Auth().currentUser;
      final userData = userDoc.data() as Map<String, dynamic>;
      setState(() {
        currentUserId = userData['id'];
      });
    } catch (e) {
      showSnackBarError(context, 'Failed to load user: $e');
    }
  }

  void _reloadEvents() {
    setState(() {
      eventsFuture = _loadEvents();
    });
  }

  Future<Map<String, List<Map<String, dynamic>>>> _loadEvents() async {
    final localEventsRaw = await DatabaseHelper.instance
        .query('Events', where: 'user_id = ?', whereArgs: [currentUserId]);

    final localEvents = localEventsRaw.map((event) {
      return {
        ...event,
        'date': Timestamp.fromMillisecondsSinceEpoch(
          DateTime.parse(event['date']).millisecondsSinceEpoch,
        )
      };
    }).toList();

    final cloudEvents = await FirebaseFirestore.instance
        .collection('Events')
        .where('user_id', isEqualTo: currentUserId)
        .get();
    return {
      'localEvents': localEvents,
      'cloudEvents': cloudEvents.docs
          .map((doc) => {
                'id': doc.id,
                'name': doc['name'],
                'location': doc['location'],
                'description': doc['description'],
                'date': doc['date'],
              })
          .toList(),
    };
  }

  Future<void> _uploadLocalEventsToCloud() async {
    setState(() {
      isUploading = true;
    });

    final localEvents = await db.query('Events');

    for (var event in localEvents) {
      await FirebaseFirestore.instance.collection('Events').add({
        'name': event['name'],
        'location': event['location'],
        'description': event['description'],
        'date': Timestamp.fromDate(DateTime.parse(event['date'])),
        'user_id': event['user_id'],
      });
    }

    showSnackBarSuccess(context, 'Local events uploaded to cloud!');
    db.delete('Events');

    setState(() {
      isUploading = false;
    });
    _reloadEvents();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Your Events',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 28.0,
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.green,
                    foregroundColor: AppColors.background,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                  onPressed: currentUserId == null
                      ? null
                      : () {
                          Navigator.pushNamed(
                            context,
                            '/create-event',
                            arguments: {'userId': currentUserId},
                          ).then((_) {
                            _reloadEvents();
                          });
                        },
                  child: const Text('Create Event'),
                ),
              ],
            ),
          ),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Local Events'),
              Tab(text: 'Cloud Events'),
            ],
          ),
        ),
        body: FutureBuilder<Map<String, List<Map<String, dynamic>>>>(
          future: eventsFuture,
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
                  style: const TextStyle(color: AppColors.white),
                ),
              );
            }

            if (!snapshot.hasData) {
              return const Center(
                child: Text(
                  'No data found.',
                  style: TextStyle(color: AppColors.white),
                ),
              );
            }

            final eventsData = snapshot.data!;
            final localEvents = eventsData['localEvents']!;
            final cloudEvents = eventsData['cloudEvents']!;

            return TabBarView(
              children: [
                _buildEventsTab(localEvents, 'No local events found.', 'local'),
                _buildEventsTab(cloudEvents, 'No cloud events found.', 'cloud'),
              ],
            );
          },
        ),
        bottomNavigationBar: const BottomBar(
          currentIndex: 1,
        ),
      ),
    );
  }

  Widget _buildEventsTab(List<Map<String, dynamic>> events, String emptyMessage,
      String cloudType) {
    if (events.isEmpty) {
      return Center(
        child: Text(
          emptyMessage,
          style: const TextStyle(color: AppColors.white),
        ),
      );
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(20.0),
            itemCount: events.length,
            itemBuilder: (context, index) {
              final event = events[index];
              return SingleEvent(
                eventId: event['id'].toString(),
                eventName: event['name'],
                eventLocation: event['location'],
                eventDate: event['date'],
                cloudType: cloudType,
                onDelete: () {
                  _reloadEvents();
                },
              );
            },
          ),
        ),
        if (cloudType == 'local')
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              child: isUploading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.green,
                        foregroundColor: AppColors.background,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
                      onPressed: _uploadLocalEventsToCloud,
                      child: const Text('Upload Local Events to Cloud'),
                    ),
            ),
          ),
      ],
    );
  }
}
