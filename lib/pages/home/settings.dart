import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hedieaty_mobile_app/auth.dart';
import 'package:hedieaty_mobile_app/components/reusable/bottom_bar.dart';
import 'package:hedieaty_mobile_app/components/reusable/custom_divider.dart';
import 'package:hedieaty_mobile_app/static/colors.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  late Future<DocumentSnapshot> userFuture;

  @override
  void initState() {
    super.initState();
    userFuture = Auth().currentUser;
  }

  void _navigateTo(BuildContext context, String routeName, [Map<String, dynamic>? arguments]) {
    Navigator.pushNamed(context, routeName, arguments: arguments).then((_) {
      setState(() {
        userFuture = Auth().currentUser;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Settings',
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
                onPressed: () async {
                  await Auth().signOut(context);
                },
                child: const Text('Sign out'),
              ),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: FutureBuilder<DocumentSnapshot>(
          future: userFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return const Center(
                  child: Text('Error fetching user data',
                      style: TextStyle(color: AppColors.white)));
            } else if (!snapshot.hasData || !snapshot.data!.exists) {
              return const Center(
                  child: Text('User not found',
                      style: TextStyle(color: AppColors.white)));
            } else {
              var userData = snapshot.data!.data() as Map<String, dynamic>;

              return SingleChildScrollView(
                child: Column(
                  children: [
                    ListTile(
                      onTap: () => _navigateTo(context, '/my-profile', {
                        'userId': userData["id"],
                        'name': userData["name"],
                        'picture': userData["picture"],
                        'preferences': userData["preferences"],
                      }),
                      title: Text(userData["name"],
                          style:
                              const TextStyle(fontSize: 20, color: AppColors.white)),
                      subtitle: Text(userData["email"],
                          style: const TextStyle(color: AppColors.white)),
                      leading: CircleAvatar(
                        radius: 30.0,
                        backgroundImage: NetworkImage(userData["picture"]),
                      ),
                    ),
                    const CustomDivider(),
                    ListTile(
                      leading: const Icon(Icons.event, color: AppColors.blue),
                      title: const Text('My Events',
                          style: TextStyle(color: AppColors.white)),
                      onTap: () => _navigateTo(context, '/my-events'),
                    ),
                    const CustomDivider(),
                    ListTile(
                      leading: const Icon(Icons.settings, color: AppColors.green),
                      title: const Text('App Preferences',
                          style: TextStyle(color: AppColors.white)),
                      onTap: () => _navigateTo(context, '/preferences'),
                    ),
                    const CustomDivider(),
                    ListTile(
                      leading: const Icon(Icons.info, color: AppColors.greyText),
                      title: const Text('About',
                          style: TextStyle(color: AppColors.white)),
                      onTap: () => _navigateTo(context, '/about'),
                    ),
                  ],
                ),
              );
            }
          },
        ),
      ),
      bottomNavigationBar: const BottomBar(
        currentIndex: 4,
      ),
    );
  }
}
