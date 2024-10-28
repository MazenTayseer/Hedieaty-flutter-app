import 'package:flutter/material.dart';
import 'package:hedieaty_mobile_app/components/__init__.dart';
import 'package:hedieaty_mobile_app/static/__init__.dart';

class YourEvents extends StatelessWidget {
  const YourEvents({super.key});

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
                onPressed: () {
                  Navigator.pushNamed(context, '/create-event');
                },
                child: const Text('Create Event'),
              ),
            ],
          ),
        ),
      ),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            children: [
              SearchEvent(),
              SizedBox(height: 18),
              SingleChildScrollView(
                child: Column(
                  children: [
                    SingleEvent(
                      eventId: "ID 1",
                      eventName: "Event Name",
                      eventLocation: "Event Location",
                      eventDate: "Event Date",
                    ),
                    SingleEvent(
                      eventId: "ID 2",
                      eventName: "Event Name",
                      eventLocation: "Event Location",
                      eventDate: "Event Date",
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: const BottomBar(
        currentIndex: 1,
      ),
    );
  }
}
