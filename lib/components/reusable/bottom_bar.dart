import 'package:flutter/material.dart';

import 'package:hedieaty_mobile_app/static/colors.dart';

class BottomBar extends StatelessWidget {
  final int currentIndex;

  const BottomBar({
    super.key,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.notifications),
          label: 'XXX',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.event),
          label: 'Events',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.people),
          label: 'Add Friend',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: 'Settings',
        ),
      ],
      currentIndex: currentIndex,
      type: BottomNavigationBarType.fixed,
      backgroundColor: AppColors.background,
      selectedItemColor: AppColors.white,
      unselectedItemColor: AppColors.greyText,
      onTap: (index) {
        switch (index) {
          case 0:
            break;
          case 1:
            Navigator.pushReplacementNamed(context, '/my-events');
            break;
          case 2:
            Navigator.pushReplacementNamed(context, '/home');
            break;
          case 3:
            Navigator.pushReplacementNamed(context, '/add-friend');
            break;
          case 4:
            Navigator.pushReplacementNamed(context, '/settings');
            break;
        }
      },
    );
  }
}
