import 'package:flutter/material.dart';
import 'package:grocery_app/provider/grocery_store_provider.dart';
import 'package:grocery_app/view/splash_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => GroceryStoreProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: const MaterialApp(
        title: 'Grocery Store',
        debugShowCheckedModeBanner: false,
        home: SplashScreen(),
      ),
    );
  }
}
