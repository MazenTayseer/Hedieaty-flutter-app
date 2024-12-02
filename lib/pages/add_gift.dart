import 'package:flutter/material.dart';
import 'package:hedieaty_mobile_app/classes/gift.dart';
import 'package:hedieaty_mobile_app/database_helper.dart';
import 'package:hedieaty_mobile_app/components/reusable/show_snack_bar.dart';
import 'package:hedieaty_mobile_app/static/colors.dart';

class AddGift extends StatefulWidget {
  final String eventId;

  const AddGift({super.key, required this.eventId});

  @override
  State<AddGift> createState() => _AddGiftState();
}

class _AddGiftState extends State<AddGift> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final TextEditingController _giftNameController = TextEditingController();
  final TextEditingController _giftDescriptionController =
      TextEditingController();
  final TextEditingController _giftPriceController = TextEditingController();
  String _giftCategory = "Technology";
  String _giftStatus = "Available";

  final database = DatabaseHelper.instance;

  Future<void> _saveToLocal() async {
    if (_formKey.currentState?.validate() ?? false) {
      Gift gift = Gift(
        name: _giftNameController.text,
        description: _giftDescriptionController.text,
        category: _giftCategory,
        price: double.parse(_giftPriceController.text),
        status: _giftStatus,
        eventId: widget.eventId,
      );

      await database.insert('Gifts', gift.toMap());
      showSnackBarSuccess(context, 'Gift saved to local database!');
      _clearFields();
    }
  }

  void _clearFields() {
    _giftNameController.clear();
    _giftDescriptionController.clear();
    _giftPriceController.clear();
    setState(() {
      _giftCategory = "Technology";
      _giftStatus = "Available";
    });
  }

  @override
  void dispose() {
    _giftNameController.dispose();
    _giftDescriptionController.dispose();
    _giftPriceController.dispose();
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
              'Add Gift',
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
                controller: _giftNameController,
                decoration: const InputDecoration(labelText: 'Gift Name'),
                style: const TextStyle(
                  color: AppColors.white,
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Enter a gift name' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _giftDescriptionController,
                decoration:
                    const InputDecoration(labelText: 'Gift Description'),
                style: const TextStyle(
                  color: AppColors.white,
                ),
                validator: (value) => value == null || value.isEmpty
                    ? 'Enter a gift description'
                    : null,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _giftCategory,
                decoration: const InputDecoration(labelText: 'Gift Category'),
                items: const [
                  DropdownMenuItem(
                    value: "Technology",
                    child: Text("Technology",
                        style: TextStyle(color: AppColors.greyText)),
                  ),
                  DropdownMenuItem(
                    value: "Clothing",
                    child: Text("Clothing",
                        style: TextStyle(color: AppColors.greyText)),
                  ),
                  DropdownMenuItem(
                    value: "Books",
                    child: Text("Books",
                        style: TextStyle(color: AppColors.greyText)),
                  ),
                  DropdownMenuItem(
                    value: "Food",
                    child: Text("Food",
                        style: TextStyle(color: AppColors.greyText)),
                  ),
                  DropdownMenuItem(
                    value: "Other",
                    child: Text("Other",
                        style: TextStyle(color: AppColors.greyText)),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    _giftCategory = value!;
                  });
                },
                style: const TextStyle(color: AppColors.white),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _giftPriceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Gift Price'),
                style: const TextStyle(
                  color: AppColors.white,
                ),
                validator: (value) => value == null ||
                        value.isEmpty ||
                        double.tryParse(value) == null
                    ? 'Enter a valid price'
                    : null,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _giftStatus,
                decoration: const InputDecoration(labelText: 'Gift Status'),
                items: const [
                  DropdownMenuItem(
                    value: "Available",
                    child: Text("Available",
                        style: TextStyle(color: AppColors.greyText)),
                  ),
                  DropdownMenuItem(
                    value: "Purchased",
                    child: Text("Purchased",
                        style: TextStyle(color: AppColors.greyText)),
                  ),
                  DropdownMenuItem(
                    value: "Pledged",
                    child: Text("Pledged",
                        style: TextStyle(color: AppColors.greyText)),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    _giftStatus = value!;
                  });
                },
                style: const TextStyle(color: AppColors.white),
              ),
              const SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveToLocal,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.blue,
                    foregroundColor: AppColors.background,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                  child: const Text('Save Gift to Local'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
