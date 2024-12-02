import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hedieaty_mobile_app/components/reusable/show_snack_bar.dart';
import 'package:hedieaty_mobile_app/static/colors.dart';

class MyProfile extends StatefulWidget {
  final String userId;
  final String name;
  final String picture;
  final String preferences;

  const MyProfile({
    super.key,
    required this.userId,
    required this.name,
    required this.picture,
    required this.preferences,
  });

  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  late TextEditingController _nameController;
  late TextEditingController _pictureController;
  late TextEditingController _preferencesController;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.name);
    _pictureController = TextEditingController(text: widget.picture);
    _preferencesController = TextEditingController(text: widget.preferences);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _pictureController.dispose();
    _preferencesController.dispose();
    super.dispose();
  }

  Future<void> _updateProfile() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(widget.userId)
          .update({
        'name': _nameController.text.trim(),
        'picture': _pictureController.text.trim(),
        'preferences': _preferencesController.text.trim(),
      });

      showSnackBarSuccess(context, 'Profile updated successfully!');
      
      Navigator.pop(context, true);
    } catch (e) {
      showSnackBarError(context, 'Failed to update profile: $e');
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
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context, true);
              },
            ),
            const SizedBox(width: 8.0),
            const Text(
              'My Profile',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28.0),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                style: const TextStyle(color: AppColors.white),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _pictureController,
                decoration: const InputDecoration(labelText: 'Picture URL'),
                style: const TextStyle(color: AppColors.white),
                validator: (value) {
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _preferencesController,
                decoration: const InputDecoration(labelText: 'Preferences'),
                style: const TextStyle(color: AppColors.white),
                validator: (value) {
                  return null;
                },
              ),
              const SizedBox(height: 20),
              isLoading
                  ? const CircularProgressIndicator()
                  : SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _updateProfile,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.green,
                          foregroundColor: AppColors.background,
                        ),
                        child: const Text('Update Profile'),
                      )),
            ],
          ),
        ),
      ),
    );
  }
}
