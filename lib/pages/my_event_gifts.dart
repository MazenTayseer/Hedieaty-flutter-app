import 'package:flutter/material.dart';
import 'package:hedieaty_mobile_app/components/gift/single_gift.dart';
import 'package:hedieaty_mobile_app/components/reusable/show_snack_bar.dart';
import 'package:hedieaty_mobile_app/static/colors.dart';
import 'package:hedieaty_mobile_app/database_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MyEventGifts extends StatefulWidget {
  final String eventId;
  final String eventName;

  const MyEventGifts({
    super.key,
    required this.eventId,
    required this.eventName,
  });

  @override
  State<MyEventGifts> createState() => _MyEventGiftsState();
}

class _MyEventGiftsState extends State<MyEventGifts> {
  late Future<Map<String, List<Map<String, dynamic>>>> giftsFuture;
  final db = DatabaseHelper.instance;
  bool isUploading = false;

  @override
  void initState() {
    super.initState();
    _reloadGifts();
  }

  void _reloadGifts() {
    setState(() {
      giftsFuture = _loadGifts();
    });
  }

  Future<Map<String, List<Map<String, dynamic>>>> _loadGifts() async {
    final localGifts = await db.query(
      'Gifts',
      where: 'event_id = ?',
      whereArgs: [widget.eventId],
    );
    final cloudGifts = await FirebaseFirestore.instance
        .collection('Gifts')
        .where('event_id', isEqualTo: widget.eventId)
        .get();
    return {
      'localGifts': localGifts,
      'cloudGifts': cloudGifts.docs
          .map((doc) => {
                'id': doc.id,
                'name': doc['name'],
                'description': doc['description'],
                'category': doc['category'],
                'price': doc['price'],
                'status': doc['status'],
              })
          .toList(),
    };
  }

  Future<void> _uploadLocalGiftsToCloud() async {
    setState(() {
      isUploading = true;
    });

    final localGifts = await db.query(
      'Gifts',
      where: 'event_id = ?',
      whereArgs: [widget.eventId],
    );

    for (var gift in localGifts) {
      await FirebaseFirestore.instance.collection('Gifts').add({
        'name': gift['name'],
        'description': gift['description'],
        'category': gift['category'],
        'price': gift['price'],
        'status': gift['status'],
        'event_id': widget.eventId,
      });
    }

    showSnackBarSuccess(context, 'Local gifts uploaded to cloud!');
    db.delete(
      'Gifts',
      where: 'event_id = ?',
      whereArgs: [widget.eventId],
    );

    setState(() {
      isUploading = false;
    });
    _reloadGifts();
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
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    const SizedBox(width: 8.0),
                    Text(
                      '${widget.eventName} Gifts',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 28.0,
                      ),
                    ),
                  ],
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.green,
                    foregroundColor: AppColors.background,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, '/add-gift', arguments: {
                      'eventId': widget.eventId,
                    }).then((_) {
                      _reloadGifts();
                    });
                  },
                  child: const Text('Add Gift'),
                ),
              ],
            ),
          ),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Local Gifts'),
              Tab(text: 'Cloud Gifts'),
            ],
          ),
        ),
        body: FutureBuilder<Map<String, List<Map<String, dynamic>>>>(
          future: giftsFuture,
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

            final giftsData = snapshot.data!;
            final localGifts = giftsData['localGifts']!;
            final cloudGifts = giftsData['cloudGifts']!;

            return TabBarView(
              children: [
                _buildGiftsTab(localGifts, 'No local gifts found.', 'local'),
                _buildGiftsTab(cloudGifts, 'No cloud gifts found.', 'cloud'),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildGiftsTab(
    List<Map<String, dynamic>> gifts,
    String emptyMessage,
    String cloudType,
  ) {
    if (gifts.isEmpty) {
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
            itemCount: gifts.length,
            itemBuilder: (context, index) {
              final gift = gifts[index];
              return SingleGift(
                giftId: gift['id'].toString(),
                giftName: gift['name'],
                giftPrice: gift['price'],
                giftStatus: gift['status'],
                cloudType: cloudType,
                onDelete: () {
                  _reloadGifts();
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
                      onPressed: _uploadLocalGiftsToCloud,
                      child: const Text('Upload Local Gifts to Cloud'),
                    ),
            ),
          ),
      ],
    );
  }
}
