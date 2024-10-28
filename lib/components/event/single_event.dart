import 'package:flutter/material.dart';
import 'package:hedieaty_mobile_app/components/__init__.dart';
import 'package:hedieaty_mobile_app/pages/__init__.dart';
import 'package:hedieaty_mobile_app/static/__init__.dart';

class SingleEvent extends StatelessWidget {
  final String eventId;
  final String eventName;
  final String eventLocation;
  final String eventDate;

  const SingleEvent({
    super.key,
    required this.eventId,
    required this.eventName,
    required this.eventLocation,
    required this.eventDate,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            Navigator.pushNamed(context, '/event-gifts',
                arguments: EventGifts(eventId: eventId));
          },
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              eventName,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0,
                                color: AppColors.white,
                              ),
                            ),
                            Text(
                              eventLocation,
                              style: const TextStyle(
                                color: AppColors.greyText,
                              ),
                            ),
                            Text(
                              eventDate,
                              style: const TextStyle(
                                color: AppColors.greyText,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.blue,
                                  foregroundColor: AppColors.white,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 6.0, vertical: 3.0),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.0),
                                  )),
                              child: const Icon(Icons.edit, size: 16.0),
                            ),
                            const SizedBox(height: 8),
                            ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.red,
                                  foregroundColor: AppColors.white,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 6.0, vertical: 3.0),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.0),
                                  )),
                              child: const Icon(Icons.delete, size: 16.0),
                            ),
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const CustomDivider(),
      ],
    );
  }
}
