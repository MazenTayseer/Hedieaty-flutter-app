import 'package:flutter/material.dart';
import 'package:hedieaty_mobile_app/static/__init__.dart';

class SearchGift extends StatelessWidget {
  const SearchGift({super.key});

  @override
  Widget build(BuildContext context) {
    return const TextField(
      decoration: InputDecoration(
        labelText: "Search...",
        prefixIcon: Icon(Icons.search),
      ),
      style: TextStyle(
        color: AppColors.white,
      ),
    );
  }
}
