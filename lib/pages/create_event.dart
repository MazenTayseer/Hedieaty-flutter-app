import 'package:flutter/material.dart';
import 'package:hedieaty_mobile_app/static/__init__.dart';

class CreateEvent extends StatefulWidget {
  const CreateEvent({super.key});

  @override
  State<CreateEvent> createState() => _CreateEventState();
}

class _CreateEventState extends State<CreateEvent> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final TextEditingController _eventNameController = TextEditingController();
  // final TextEditingController _eventDateController = TextEditingController();
  final TextEditingController _eventLocationController = TextEditingController();
  final TextEditingController _eventDescriptionController = TextEditingController();

  @override
  void dispose() {
    _eventNameController.dispose();
    _eventLocationController.dispose();
    _eventDescriptionController.dispose();
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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              const SizedBox(width: 8.0),
              const Text(
                'Create Event',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 28.0,
                ),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _eventNameController,
                decoration: const InputDecoration(
                  labelText: 'Event Name',
                ),
                style: const TextStyle(color: AppColors.white),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Enter an event name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _eventLocationController,
                decoration: const InputDecoration(
                  labelText: 'Event Location',
                ),
                style: const TextStyle(color: AppColors.white),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Enter an event location';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _eventDescriptionController,
                decoration: const InputDecoration(
                  labelText: 'Event Description',
                ),
                style: const TextStyle(color: AppColors.white),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Enter an event description';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 18),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.green,
                  foregroundColor: AppColors.background,
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
                onPressed: () {},
                child: const SizedBox(
                  width: double.infinity,
                  child: Center(
                    child: Text(
                      'Create Event',
                      style: TextStyle(
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
