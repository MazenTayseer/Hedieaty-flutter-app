import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hedieaty_mobile_app/auth.dart';
import 'package:hedieaty_mobile_app/components/reusable/bottom_bar.dart';
import 'package:hedieaty_mobile_app/components/reusable/show_snack_bar.dart';
import 'package:hedieaty_mobile_app/static/colors.dart';


class AddFriend extends StatefulWidget {
  const AddFriend({super.key});

  @override
  State<AddFriend> createState() => _AddFriendState();
}

class _AddFriendState extends State<AddFriend> {
  final TextEditingController _numberController = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    _numberController.dispose();
    super.dispose();
  }

  Future<void> _sendFriendRequest() async {
    final phoneNumber = _numberController.text.trim();

    if (phoneNumber.isEmpty) {
      showSnackBarError(context, 'Please enter a valid number.');
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final currentUser = await Auth().currentUser;
      final currentUserData = currentUser.data() as Map<String, dynamic>;

      final currentUserId = currentUserData['id'];

      final querySnapshot = await FirebaseFirestore.instance
          .collection('Users')
          .where('phone', isEqualTo: phoneNumber)
          .get();

      if (querySnapshot.docs.isEmpty) {
        showSnackBarError(context, 'User not found.');
        setState(() {
          isLoading = false;
        });
        return;
      }

      final friendDoc = querySnapshot.docs.first;
      final friendId = friendDoc.id;

      if (friendId == currentUserId) {
        showSnackBarError(context, 'You cannot add yourself as a friend.');
        setState(() {
          isLoading = false;
        });
        return;
      }

      await FirebaseFirestore.instance.collection('Users').doc(currentUserId).update({
        'friends': FieldValue.arrayUnion([
          {'friend_id': friendId, 'status': 'accepted'}
        ])
      });

      await FirebaseFirestore.instance.collection('Users').doc(friendId).update({
        'friends': FieldValue.arrayUnion([
          {'friend_id': currentUserId, 'status': 'accepted'}
        ])
      });

      showSnackBarSuccess(context, 'Friend added successfully!');
      _numberController.clear();
    } catch (e) {
      showSnackBarError(context, 'Failed to add friend: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Padding(
          padding: EdgeInsets.only(top: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Add Friend',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 28.0,
                ),
              )
            ],
          ),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _numberController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Enter Number',
                ),
                style: const TextStyle(
                  color: AppColors.white,
                )
              ),
              const SizedBox(height: 18.0),
              isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _sendFriendRequest,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.green,
                        foregroundColor: AppColors.background,
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
                      child: const SizedBox(
                        width: double.infinity,
                        child: Center(
                          child: Text(
                            'Send Friend Request',
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const BottomBar(
        currentIndex: 3,
      ),
    );
  }
}
