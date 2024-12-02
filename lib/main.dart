import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hedieaty_mobile_app/database_helper.dart';
import 'package:hedieaty_mobile_app/routes.dart';

import 'package:hedieaty_mobile_app/static/colors.dart';
import 'package:hedieaty_mobile_app/widget_tree.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDatabase();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

Future<void> initializeDatabase() async {
  final dbHelper = DatabaseHelper.instance;
  await dbHelper.database;
  print('Database initialized successfully.');
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hedeaity',
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.background,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.background,
          foregroundColor: AppColors.white,
        ),
        inputDecorationTheme: const InputDecorationTheme(
          filled: true,
          fillColor: AppColors.greyBackground,
          labelStyle: TextStyle(color: AppColors.greyText),
          prefixIconColor: AppColors.greyText,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(12.0)),
            borderSide: BorderSide(
              color: AppColors.background,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.green),
          ),
        ),
      ),
      home: const WidgetTree(),
      routes: appRoutes,
      onGenerateRoute: generateRoute,
      initialRoute: '/home',
    );
  }
}
