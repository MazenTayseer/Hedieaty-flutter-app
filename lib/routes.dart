import 'package:flutter/material.dart';
import 'package:hedieaty_mobile_app/pages/add_gift.dart';
import 'package:hedieaty_mobile_app/pages/auth/sign_in.dart';
import 'package:hedieaty_mobile_app/pages/auth/sign_up.dart';
import 'package:hedieaty_mobile_app/pages/chat_screen.dart';
import 'package:hedieaty_mobile_app/pages/create_event.dart';
import 'package:hedieaty_mobile_app/pages/event_details.dart';
import 'package:hedieaty_mobile_app/pages/home/add_friend.dart';
import 'package:hedieaty_mobile_app/pages/home/my_events.dart';
import 'package:hedieaty_mobile_app/pages/home/settings.dart';
import 'package:hedieaty_mobile_app/pages/my_event_gifts.dart';
import 'package:hedieaty_mobile_app/pages/settings/my_profile.dart';
import 'package:hedieaty_mobile_app/widget_tree.dart';

Map<String, WidgetBuilder> appRoutes = {
  '/home': (context) => const WidgetTree(),
  '/settings': (context) => const Settings(),
  '/add-friend': (context) => const AddFriend(),
  '/my-events': (context) => const MyEvents(),
  '/sign-in': (context) => const SignIn(),
  '/sign-up': (context) => const SignUp(),
};

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case '/my-event-gifts':
      final args = settings.arguments as MyEventGifts;
      return MaterialPageRoute(
        builder: (context) => MyEventGifts(
          eventId: args.eventId,
          eventName: args.eventName,
        ),
      );
    case '/chat-screen':
      final args = settings.arguments as ChatScreen;
      return MaterialPageRoute(
        builder: (context) => ChatScreen(
          userId: args.userId,
          contactName: args.contactName,
          chatImage: args.chatImage,
        ),
      );
    case '/create-event':
      final args = settings.arguments as Map<String, dynamic>;
      return MaterialPageRoute(
        builder: (context) => CreateEvent(
          userId: args["userId"],
        ),
      );
    case '/add-gift':
      final args = settings.arguments as Map<String, dynamic>;
      return MaterialPageRoute(
        builder: (context) => AddGift(
          eventId: args["eventId"],
        ),
      );
    case '/event-details':
      final args = settings.arguments as Map<String, dynamic>;
      return MaterialPageRoute(
        builder: (context) => EventDetailsPage(
          eventId: args["eventId"],
          eventName: args["eventName"],
          eventLocation: args["eventLocation"],
          eventDate: args["eventDate"],
          eventDescription: args["eventDescription"],
        ),
      );
    case '/my-profile':
      final args = settings.arguments as Map<String, dynamic>;
      return MaterialPageRoute(
        builder: (context) => MyProfile(
          userId: args["userId"],
          name: args["name"],
          picture: args["picture"],
          preferences: args["preferences"],
        ),
      );
    default:
      return MaterialPageRoute(
        builder: (context) => const WidgetTree(),
      );
  }
}
