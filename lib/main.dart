import 'package:flutter/material.dart';
import 'package:hedieaty_mobile_app/components/__init__.dart';
import 'package:hedieaty_mobile_app/pages/__init__.dart';

import 'package:hedieaty_mobile_app/static/__init__.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hedeaity',
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.background,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.background,
          foregroundColor: AppColors.white,
        ),
        inputDecorationTheme: const InputDecorationTheme(
          filled: true,
          fillColor: AppColors.greyBackground,
          labelStyle: TextStyle(color: AppColors.greyText),
          prefixIconColor: AppColors.greyText,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(12.0)),
            borderSide: BorderSide(
              color: AppColors.background,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.green),
          ),
        ),
      ),
      home: const HomePage(),
      onGenerateRoute: (RouteSettings settings) {
        switch (settings.name) {
          case '/home':
            return MaterialPageRoute(builder: (context) => const HomePage());
          case '/add-friend':
            return MaterialPageRoute(builder: (context) => const AddFriend());
          case '/create-event':
            return MaterialPageRoute(builder: (context) => const CreateEvent());
          case '/your-events':
            return MaterialPageRoute(builder: (context) => const YourEvents());
          case '/event-gifts':
            final args = settings.arguments as EventGifts;
            return MaterialPageRoute(
              builder: (context) => EventGifts(
                eventId: args.eventId,
              )
            );
          case '/chat-screen':
            final args = settings.arguments as ChatScreen;
            return MaterialPageRoute(
              builder: (context) => ChatScreen(
                contactName: args.contactName,
                chatImage: args.chatImage,
              ),
            );
          default:
            return MaterialPageRoute(builder: (context) => const HomePage());
        }
      },
      initialRoute: '/home',
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

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
                  onPressed: () {
                    Navigator.pushNamed(context, '/create-event');
                  },
                  child: const Text('Create Event')
                )
            ],
          ),
        )
      ),
        body: const Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            children: [
              SearchChat(),
              SizedBox(height: 18),
              SingleChildScrollView(
                child: Column(
                  children: [
                    SingleChat(
                      contactName: 'Mazen',
                      lastEvent: 'Birthday party',
                      unreadMessages: 2,
                      chatImage: StaticData.chatImage,
                    ),
                    SingleChat(
                      contactName: 'Marwan',
                      lastEvent: 'Graduation',
                      unreadMessages: 0,
                      chatImage: StaticData.chatImage,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: const BottomBar(
          currentIndex: 2,
        ));
  }
}
