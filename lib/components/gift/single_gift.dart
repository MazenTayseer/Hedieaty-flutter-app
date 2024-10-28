import 'package:flutter/material.dart';
import 'package:hedieaty_mobile_app/components/__init__.dart';
import 'package:hedieaty_mobile_app/static/__init__.dart';

class SingleGift extends StatelessWidget {
  final String giftId;
  final String giftName;
  final double giftPrice;


  const SingleGift({
    super.key,
    required this.giftId,
    required this.giftName,
    required this.giftPrice,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () {

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
                              giftName,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0,
                                color: AppColors.white,
                              ),
                            ),
                            Text(
                              '\$$giftPrice',
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
