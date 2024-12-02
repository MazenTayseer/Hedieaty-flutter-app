import 'package:flutter/material.dart';
import 'package:hedieaty_mobile_app/classes/event.dart';
import 'package:hedieaty_mobile_app/database_helper.dart';
import 'package:hedieaty_mobile_app/components/reusable/show_snack_bar.dart';
import 'dart:async';
import 'package:hedieaty_mobile_app/static/colors.dart';

class CreateEvent extends StatefulWidget {
  final String userId;

  const CreateEvent({super.key, required this.userId});

  @override
  State<CreateEvent> createState() => _CreateEventState();
}

class _CreateEventState extends State<CreateEvent> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final TextEditingController _eventNameController = TextEditingController();
  final TextEditingController _eventLocationController =
      TextEditingController();
  final TextEditingController _eventDescriptionController =
      TextEditingController();
  DateTime? _selectedDate;

  final database = DatabaseHelper.instance;

  Future<void> _saveToLocal() async {
    if (_formKey.currentState?.validate() ?? false) {
      if (_selectedDate == null) {
        showSnackBarError(context, 'Please select a date for the event!');
        return;
      }

      Event event = Event(
        name: _eventNameController.text,
        location: _eventLocationController.text,
        description: _eventDescriptionController.text,
        date: _selectedDate!,
        userId: widget.userId,
      );

      await database.insert('Events', event.toMap());
      showSnackBarSuccess(context, 'Event saved to local database!');
      _clearFields();
    }
  }

  void _clearFields() {
    _eventNameController.clear();
    _eventLocationController.clear();
    _eventDescriptionController.clear();
    setState(() {
      _selectedDate = null;
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

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
        title: Row(
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
                controller: _eventNameController,
                decoration: const InputDecoration(labelText: 'Event Name'),
                style: const TextStyle(
                  color: AppColors.white,
                ),
                validator: (value) => value == null || value.isEmpty
                    ? 'Enter an event name'
                    : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _eventLocationController,
                decoration: const InputDecoration(labelText: 'Event Location'),
                style: const TextStyle(
                  color: AppColors.white,
                ),
                validator: (value) => value == null || value.isEmpty
                    ? 'Enter an event location'
                    : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _eventDescriptionController,
                decoration:
                    const InputDecoration(labelText: 'Event Description'),
                style: const TextStyle(
                  color: AppColors.white,
                ),
                validator: (value) => value == null || value.isEmpty
                    ? 'Enter an event description'
                    : null,
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    style: const TextStyle(color: AppColors.white),
                    _selectedDate == null
                        ? 'No date chosen!'
                        : 'Date: ${_selectedDate.toString().split(' ')[0]}',
                  ),
                  TextButton(
                    onPressed: () => _selectDate(context),
                    child: const Text('Choose Date',
                        style: TextStyle(color: AppColors.white)),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => _saveToLocal(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.blue,
                    foregroundColor: AppColors.background,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                  child: const Text('Save to Local'),
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}
