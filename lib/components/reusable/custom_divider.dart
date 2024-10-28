import 'package:flutter/material.dart';
import '../../static/colors.dart';

class CustomDivider extends StatelessWidget {
  const CustomDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return const Divider(
      color: AppColors.greyText,
      thickness: 0.5,
      height: 30,
    );
  }
}