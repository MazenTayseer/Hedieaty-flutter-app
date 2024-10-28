import 'package:flutter/material.dart';
import 'package:hedieaty_mobile_app/components/__init__.dart';
import 'package:hedieaty_mobile_app/static/__init__.dart';

class EventGifts extends StatelessWidget {
  final String eventId;

  const EventGifts({
    super.key,
    required this.eventId,
  });

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
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  const SizedBox(width: 8.0),
                  Text(
                    '$eventId Gifts',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 28.0,
                    ),
                  ),
                ],
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
                  Navigator.pushNamed(context, '/add-gift');
                },
                child: const Text('Add Gift'),
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
              SearchGift(),
              SizedBox(height: 18),
              SingleChildScrollView(
                child: Column(
                  children: [
                    SingleGift(
                      giftId: "ID GIFT 1",
                      giftName: "Tshirt",
                      giftPrice: 10.0,
                    ),
                    SingleGift(
                      giftId: "ID GIFT 1",
                      giftName: "Shoes",
                      giftPrice: 60.0,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
