import 'package:flutter/material.dart';
import 'package:hedieaty_mobile_app/static/colors.dart';

void showSnackBarSuccess(BuildContext context, String message,
    {Color backgroundColor = AppColors.green}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: backgroundColor,
      duration: const Duration(seconds: 5),
    ),
  );
}

void showSnackBarError(BuildContext context, String message,
    {Color backgroundColor = AppColors.red}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: backgroundColor,
      duration: const Duration(seconds: 5),
    ),
  );
}
