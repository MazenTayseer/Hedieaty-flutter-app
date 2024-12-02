import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hedieaty_mobile_app/auth.dart';
import 'package:hedieaty_mobile_app/components/chat/single_chat.dart';
import 'package:hedieaty_mobile_app/components/reusable/bottom_bar.dart';
import 'package:hedieaty_mobile_app/components/reusable/custom_divider.dart';

import 'package:hedieaty_mobile_app/components/reusable/show_snack_bar.dart';
import 'package:hedieaty_mobile_app/static/colors.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Map<String, dynamic>>> friendsFuture;
  List<Map<String, dynamic>> friendsList = [];
  List<Map<String, dynamic>> filteredFriends = [];
  final TextEditingController _searchController = TextEditingController();
  String? currentUserId;

  @override
  void initState() {
    super.initState();
    _loadCurrentUser();
    friendsFuture = getFriends();
  }

  void _reloadEvents() {
    setState(() {
      friendsFuture = getFriends();
    });
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

  Future<List<Map<String, dynamic>>> getFriends() async {
    try {
      final userDoc = await Auth().currentUser;
      final userData = userDoc.data() as Map<String, dynamic>;

      if (!userData.containsKey('friends')) {
        return [];
      }

      final userFriends = userData['friends'] as List<dynamic>;
      final friends = <Map<String, dynamic>>[];

      for (var friendEntry in userFriends) {
        if (friendEntry['status'] != 'accepted') {
          continue;
        }

        final friendId = friendEntry['friend_id'];

        final friendDoc = await FirebaseFirestore.instance
            .collection('Users')
            .doc(friendId)
            .get();

        if (!friendDoc.exists) continue;

        final eventsSnapshot = await FirebaseFirestore.instance
            .collection('Events')
            .where('user_id', isEqualTo: friendId)
            .orderBy('date', descending: true)
            .limit(1)
            .get();

        final upcomingEventsNumber = await FirebaseFirestore.instance
            .collection('Events')
            .where('user_id', isEqualTo: friendId)
            .where('date',
                isGreaterThanOrEqualTo: Timestamp.fromDate(DateTime.now()))
            .get();

        String lastEventName = 'No events yet';

        if (eventsSnapshot.docs.isNotEmpty) {
          final lastEvent = eventsSnapshot.docs.first.data();
          lastEventName = lastEvent['name'];
        }

        final friendData = friendDoc.data() as Map<String, dynamic>;
        friends.add({
          'id': friendDoc.id,
          'name': friendData['name'],
          'email': friendData['email'],
          'picture': friendData['picture'],
          'lastEvent': lastEventName,
          'numberOfUpcomingEvents': upcomingEventsNumber.docs.length,
        });
      }

      setState(() {
        friendsList = friends;
        filteredFriends = friends;
      });

      return friends;
    } catch (e) {
      throw Exception('Failed to load friends: $e');
    }
  }

  void _filterFriends(String query) {
    setState(() {
      filteredFriends = friendsList
          .where((friend) => friend['name']
              .toLowerCase()
              .contains(_searchController.text.toLowerCase()))
          .toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Hedeaity',
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
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              onChanged: (value) => _filterFriends(value),
              style: const TextStyle(
                color: AppColors.white,
              ),
              decoration: InputDecoration(
                labelText: "Search...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
            ),
            const SizedBox(height: 18),
            Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: friendsFuture,
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

                  if (filteredFriends.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.group_off,
                            size: 100,
                            color: AppColors.greyText,
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'No friends found.',
                            style: TextStyle(
                              color: AppColors.greyText,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(height: 8),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.green,
                              foregroundColor: AppColors.background,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 24),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                            ),
                            onPressed: () {
                              Navigator.pushNamed(context, '/add-friend');
                            },
                            child: const Text('Add a Friend'),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: filteredFriends.length,
                    itemBuilder: (context, index) {
                      final friend = filteredFriends[index];
                      return Column(
                        children: [
                          SingleChat(
                            userId: friend['id'],
                            contactName: friend['name'],
                            lastEvent: friend['lastEvent'],
                            unreadMessages: friend['numberOfUpcomingEvents'],
                            chatImage: NetworkImage(friend['picture']),
                          ),
                          const CustomDivider(),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomBar(
        currentIndex: 2,
      ),
    );
  }
}
